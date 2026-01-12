import 'dart:io';

/// Utility class to check internet connectivity
class ConnectivityChecker {
  /// Check if device has internet connection
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check connectivity with custom host
  static Future<bool> checkHost(String host) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}