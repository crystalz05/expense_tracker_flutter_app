import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive key-value pairs
/// Uses platform-specific secure storage:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences (Android Keystore)
/// - Web: Not recommended for sensitive data
/// - Linux/Windows: libsecret / Windows Credential Store
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  /// Save a secure value
  Future<void> saveSecureValue(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      throw SecureStorageException('Failed to save secure value: $e');
    }
  }

  /// Retrieve a secure value
  Future<String?> getSecureValue(String key) async {
    try {
      return await _storage.read(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      throw SecureStorageException('Failed to read secure value: $e');
    }
  }

  /// Delete a secure value
  Future<void> deleteSecureValue(String key) async {
    try {
      await _storage.delete(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      throw SecureStorageException('Failed to delete secure value: $e');
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      throw SecureStorageException('Failed to check key existence: $e');
    }
  }

  /// Delete all secure values (use with caution!)
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      throw SecureStorageException('Failed to delete all values: $e');
    }
  }

  /// Android-specific options
  AndroidOptions _getAndroidOptions() {
    return const AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    );
  }

  /// iOS-specific options
  IOSOptions _getIOSOptions() {
    return const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );
  }
}

/// Custom exception for secure storage operations
class SecureStorageException implements Exception {
  final String message;
  SecureStorageException(this.message);

  @override
  String toString() => 'SecureStorageException: $message';
}
