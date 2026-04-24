import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyToken = 'auth_token';
  static const _keyOnboarding = 'has_seen_onboarding';

  //auth token
  static Future<void> saveToken(String token) async =>
      _storage.write(key: _keyToken, value: token);

  static Future<String?> getToken() async => _storage.read(key: _keyToken);

  //onboarding Logic
  static Future<void> setOnboardingSeen() async =>
      _storage.write(key: _keyOnboarding, value: 'true');

  static Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: _keyOnboarding);
    return value == 'true';
  }

  //clear
  static Future<void> clearAll() async {
    await _storage.delete(key: _keyToken);
  }
}
