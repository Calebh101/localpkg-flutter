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

  static bool _is(String platform) {
    return get() == platform;
  }

  static String _get(String input, {bool formal = false}) {
    if (formal == true) {
      switch (input) {
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
      }
    }
    return input;
  }

  static String get({bool formal = false}) {
    if (kIsWeb) {
      return _get("web", formal: formal);
    }
    if (kIsWasm) {
      return _get("wasm", formal: formal);
    }
    if (Platform.isAndroid) {
      return _get("android", formal: formal);
    }
    if (Platform.isIOS) {
      return _get("ios", formal: formal);
    }
    if (Platform.isLinux) {
      return _get("linux", formal: formal);
    }
    if (Platform.isMacOS) {
      return _get("macos", formal: formal);
    }
    if (Platform.isWindows) {
      return _get("windows", formal: formal);
    }
    if (Platform.isFuchsia) {
      return _get("fuchsia", formal: formal);
    }
    return _get('unknown', formal: formal);
  }
}