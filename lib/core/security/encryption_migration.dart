import 'dart:io';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'database_encryption_key_manager.dart';

/// Handles migration from unencrypted to encrypted database
class EncryptionMigration {
  final DatabaseEncryptionKeyManager _keyManager;

  EncryptionMigration(this._keyManager);

  /// Check if database needs migration (exists but unencrypted)
  Future<bool> needsMigration(String dbPath) async {
    final dbFile = File(dbPath);
    
    // If database doesn't exist, no migration needed
    if (!await dbFile.exists()) {
      return false;
    }

    // If we already have an encryption key, assume it's encrypted
    if (await _keyManager.hasEncryptionKey()) {
      return false;
    }

    // Database exists but no encryption key = needs migration
    return true;
  }

  /// Migrate unencrypted database to encrypted version
  Future<void> migrateToEncrypted(String dbPath, String encryptionKey) async {
    try {
      final dbFile = File(dbPath);
      
      if (!await dbFile.exists()) {
        throw MigrationException('Database file does not exist at: $dbPath');
      }

      // Create paths
      final dbDirectory = dbPath.substring(0, dbPath.lastIndexOf('/'));
      final tempPath = '$dbDirectory/temp_encrypted.db';
      final backupPath = '$dbDirectory/backup_unencrypted.db';

      // Step 1: Open unencrypted database
      final unencryptedDb = await openDatabase(
        dbPath,
        version: 1,
      );

      // Step 2: Create new encrypted database
      final encryptedDb = await openDatabase(
        tempPath,
        version: 1,
        password: encryptionKey,
      );

      // Step 3: Copy all data
      await _copyDatabaseData(unencryptedDb, encryptedDb);

      // Step 4: Close both databases
      await unencryptedDb.close();
      await encryptedDb.close();

      // Step 5: Backup original and replace with encrypted version
      await dbFile.copy(backupPath);
      await dbFile.delete();
      await File(tempPath).copy(dbPath);
      await File(tempPath).delete();

      // Optional: Delete backup after successful migration
      // await File(backupPath).delete();
      
    } catch (e) {
      throw MigrationException('Failed to migrate database: $e');
    }
  }

  /// Copy all data from one database to another
  Future<void> _copyDatabaseData(Database source, Database target) async {
    // Get all table names
    final tables = await source.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_%'",
    );

    for (final table in tables) {
      final tableName = table['name'] as String;
      
      // Get all rows from source table
      final rows = await source.query(tableName);
      
      if (rows.isEmpty) continue;

      // Insert into target database
      final batch = target.batch();
      for (final row in rows) {
        batch.insert(tableName, row);
      }
      await batch.commit(noResult: true);
    }
  }
}

/// Custom exception for migration operations
class MigrationException implements Exception {
  final String message;
  MigrationException(this.message);

  @override
  String toString() => 'MigrationException: $message';
}
