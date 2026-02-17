import 'dart:async';
import 'package:floor/floor.dart';

import 'app_database.dart';

/// Factory for creating encrypted Floor databases
class EncryptedDatabaseFactory {
  /// Creates an encrypted database instance with the provided encryption key
  static Future<AppDatabase> createEncrypted({
    required String databaseName,
    required String encryptionKey,
  }) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(databaseName)
        .addCallback(Callback(
          onCreate: (database, version) async {
            // Set encryption password on database creation
            await database.rawQuery('PRAGMA key = "$encryptionKey"');
          },
          onOpen: (database) async {
            // Set encryption password when opening existing database
            await database.rawQuery('PRAGMA key = "$encryptionKey"');
          },
        ))
        .build();

    return database;
  }

  /// Creates an unencrypted database instance (for testing or migration)
  static Future<AppDatabase> createUnencrypted({
    required String databaseName,
  }) async {
    return await $FloorAppDatabase
        .databaseBuilder(databaseName)
        .build();
  }
}
