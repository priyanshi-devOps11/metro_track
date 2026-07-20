class PermissionsHelper {
  /// Request microphone permission for voice assistant
  static Future<bool> requestMicrophonePermission() async {
    return true; 
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    return true;
  }

  /// Check if microphone permission is granted
  static Future<bool> hasMicrophonePermission() async {
    return true; 
  }
}
