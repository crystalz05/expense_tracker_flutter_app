import 'dart:io';

import 'package:floor/floor.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite_cipher;
import 'package:sqflite/sqflite.dart' as sqflite;

import 'app_database.dart';

/// Factory for creating encrypted Floor databases using SQLCipher.
///
/// **Key design decision:** The global [databaseFactory] must be overridden
/// with SQLCipher's factory BEFORE calling Floor's builder. Floor's generated
/// code references the global sqflite factory directly, so without this
/// override, [PRAGMA key] becomes a no-op and the database is written as
/// plain unencrypted SQLite — causing HMAC mismatch / SQLITE_CORRUPT[11]
/// on every subsequent open.
///
/// The encryption key is additionally applied in [onConfigure] as a
/// belt-and-suspenders measure; it fires before Floor reads the schema.
///
/// **Corruption recovery:** If [build()] throws a corruption error (e.g. an
/// app reinstall wiped FlutterSecureStorage so the key changed, or Android's
/// DefaultDatabaseErrorHandler recreated a blank unencrypted file), the stale
/// file plus any WAL/SHM side-files are deleted and the build is retried once
/// to produce a fresh encrypted database.
class EncryptedDatabaseFactory {
  EncryptedDatabaseFactory._();

  // -------------------------------------------------------------------------
  // Internal helpers
  // -------------------------------------------------------------------------

  /// Returns the full path to the database file with [databaseName].
  static Future<String> _databasePath(String databaseName) async {
    final dbsPath = await sqflite_cipher.getDatabasesPath();
    return '$dbsPath/$databaseName';
  }

  /// Deletes the database file and any WAL / SHM side-files if they exist.
  static Future<void> _deleteDatabaseFile(String databaseName) async {
    final dbPath = await _databasePath(databaseName);

    for (final path in [dbPath, '$dbPath-wal', '$dbPath-shm']) {
      final file = File(path);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {
          // Best-effort; carry on.
        }
      }
    }
  }

  /// Returns `true` when [error] looks like a SQLite corruption / key-mismatch
  /// error that we should recover from by deleting the stale file.
  static bool _isCorruptionError(Object error) {
    final msg = error.toString().toLowerCase();
    return msg.contains('sqlite_corrupt') ||
        msg.contains('code 11') ||
        msg.contains('malformed') ||
        msg.contains('hmac') ||
        msg.contains('not a database') ||
        msg.contains('invalid');
  }

  /// Builds an encrypted [AppDatabase].
  ///
  /// Overrides the global [databaseFactory] with SQLCipher's implementation
  /// so that Floor's generated builder opens the file through the SQLCipher
  /// native library. Without this, [PRAGMA key] in [onConfigure] is silently
  /// ignored by the regular SQLite engine.
  static Future<AppDatabase> _buildDatabase(
      String databaseName,
      String encryptionKey,
      ) async {
    // ✅ Critical fix: point the global factory to SQLCipher BEFORE Floor
    // touches the database. Floor's generated app_database.g.dart resolves
    // `databaseFactory` at call-time from the sqflite package global, so this
    // must happen here, not once at app startup.
    sqflite.databaseFactory = sqflite_cipher.databaseFactory;

    return $FloorAppDatabase
        .databaseBuilder(databaseName)
        .addCallback(
      Callback(
        // onConfigure fires before any schema reads or header parsing —
        // the only correct window to apply the SQLCipher key with Floor.
        onConfigure: (db) async {
          await db.rawQuery('PRAGMA key = "$encryptionKey"');
        },
      ),
    )
        .build();
  }

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Creates an encrypted [AppDatabase] protected by [encryptionKey].
  ///
  /// On first-open failures caused by corruption or a key mismatch the stale
  /// database file is deleted and a single retry creates a clean encrypted DB.
  static Future<AppDatabase> createEncrypted({
    required String databaseName,
    required String encryptionKey,
  }) async {
    try {
      return await _buildDatabase(databaseName, encryptionKey);
    } catch (e) {
      if (_isCorruptionError(e)) {
        // File is corrupt or was written with a different (or no) key.
        // Wipe it and its side-files, then start fresh.
        await _deleteDatabaseFile(databaseName);
        return await _buildDatabase(databaseName, encryptionKey);
      }
      rethrow;
    }
  }

  /// Creates a plain, unencrypted [AppDatabase] (useful for tests or when
  /// migrating away from encryption).
  static Future<AppDatabase> createUnencrypted({
    required String databaseName,
  }) async {
    // Reset to the default sqflite factory in case it was previously
    // overridden by a call to [createEncrypted].
    sqflite.databaseFactory = sqflite.databaseFactory;

    return $FloorAppDatabase
        .databaseBuilder(databaseName)
        .build();
  }
}