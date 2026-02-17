import 'dart:convert';
import 'dart:math';
import 'secure_storage_service.dart';

/// Manages encryption keys for the SQLite database
/// - Generates secure random keys on first launch
/// - Stores keys in platform secure storage
/// - Provides keys for database encryption/decryption
class DatabaseEncryptionKeyManager {
  final SecureStorageService _secureStorage;
  
  static const String _encryptionKeyStorageKey = 'db_encryption_key';
  static const int _keyLengthBytes = 32; // 256-bit key for AES-256

  DatabaseEncryptionKeyManager(this._secureStorage);

  /// Get the database encryption key
  /// Generates a new key if one doesn't exist
  Future<String> getOrCreateEncryptionKey() async {
    try {
      // Check if key already exists
      final existingKey = await _secureStorage.getSecureValue(_encryptionKeyStorageKey);
      
      if (existingKey != null && existingKey.isNotEmpty) {
        return existingKey;
      }

      // Generate new key if none exists
      final newKey = _generateSecureKey();
      await _secureStorage.saveSecureValue(_encryptionKeyStorageKey, newKey);
      
      return newKey;
    } catch (e) {
      throw DatabaseEncryptionException('Failed to get or create encryption key: $e');
    }
  }

  /// Check if an encryption key exists
  Future<bool> hasEncryptionKey() async {
    try {
      return await _secureStorage.containsKey(_encryptionKeyStorageKey);
    } catch (e) {
      throw DatabaseEncryptionException('Failed to check for encryption key: $e');
    }
  }

  /// Delete the encryption key (WARNING: This will make the database unreadable!)
  Future<void> deleteEncryptionKey() async {
    try {
      await _secureStorage.deleteSecureValue(_encryptionKeyStorageKey);
    } catch (e) {
      throw DatabaseEncryptionException('Failed to delete encryption key: $e');
    }
  }

  /// Rotate the encryption key (for future implementation)
  /// This would require re-encrypting the entire database
  Future<String> rotateEncryptionKey() async {
    // TODO: Implement key rotation with database re-encryption
    throw UnimplementedError('Key rotation not yet implemented');
  }

  /// Generate a cryptographically secure random key
  String _generateSecureKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(_keyLengthBytes, (_) => random.nextInt(256));
    
    // Convert to base64 for storage
    return base64Url.encode(bytes);
  }
}

/// Custom exception for database encryption operations
class DatabaseEncryptionException implements Exception {
  final String message;
  DatabaseEncryptionException(this.message);

  @override
  String toString() => 'DatabaseEncryptionException: $message';
}
