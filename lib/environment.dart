import 'dart:io';
import 'package:flutter/foundation.dart';

class Environment {
  Environment();

  static bool get windows => _is('windows');
  static bool get macos => _is('macos');
  static bool get linux => _is('linux');
  static bool get ios => _is('ios');
  static bool get android => _is('android');
  static bool get web => _is('web');
  static bool get wasm => _is('wasm');
  static bool get fuchsia => _is('fuchsia');

  static bool get desktop => _is('windows') || _is('macos') || _is('linux');
  static bool get mobile => _is('ios') || _is('android');
  static bool get online => _is('web') || _is('wasm');
  static bool get debug => kDebugMode;

  static bool _is(String platform) {
    return get() == platform;
  }

  static String _get(String input) {
    return input;
  }

  static String format(String platform) {
    switch (platform) {
      case 'web':
        return 'Web';
      case 'wasm':
        return 'WASM';
      case 'android':
        return 'Android';
      case 'ios':
        return 'iOS';
      case 'linux':
        return 'Linux';
      case 'macos':
        return 'macOS';
      case 'windows':
        return 'Windows';
      case 'fuchsia':
        return 'Fuchsia';
      case 'desktop':
        return 'Desktop';
      case 'mobile':
        return 'Mobile';
      case 'online':
        return 'Online';
      case 'debug':
        return 'Debug';
      default:
        throw Exception('Unknown platform: $platform');
    }
  }

  static String get() {
    if (kIsWeb) {
      return _get("web");
    }
    if (kIsWasm) {
      return _get("wasm");
    }
    if (Platform.isAndroid) {
      return _get("android");
    }
    if (Platform.isIOS) {
      return _get("ios");
    }
    if (Platform.isLinux) {
      return _get("linux");
    }
    if (Platform.isMacOS) {
      return _get("macos");
    }
    if (Platform.isWindows) {
      return _get("windows");
    }
    if (Platform.isFuchsia) {
      return _get("fuchsia");
    }
    return _get('unknown');
  }
}