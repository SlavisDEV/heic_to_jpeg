import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef _ConvertFunc = Future<Uint8List> Function(Uint8List bytes);

class HeicToJpeg {
  static const MethodChannel _channel = MethodChannel('heic_to_jpeg');
  static _ConvertFunc? _webConvert;

  static void registerWeb(_ConvertFunc impl) {
    _webConvert = impl;
  }

  static Future<Uint8List> convert(Uint8List heicBytes) async {
    if (kIsWeb) {
      if (_webConvert == null) {
        throw PlatformException(
          code: 'no_web_impl',
          message: 'Web implementation not registered',
        );
      }
      return await _webConvert!(heicBytes);
    }

    final result = await _channel.invokeMethod('convert', heicBytes);
    if (result is Uint8List) return result;
    if (result is List) return Uint8List.fromList(List<int>.from(result));
    throw PlatformException(
      code: 'bad_result',
      message: 'Unexpected result type',
    );
  }
}
