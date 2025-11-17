import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'heic_to_jpeg.dart';

class HeicToJpegWeb {
  static void registerWith(Registrar registrar) {
    HeicToJpeg.registerWeb(_convertWeb);
  }

  static Future<Uint8List> _convertWeb(Uint8List heicBytes) async {
    final blob = web.Blob(
        [heicBytes.toJS].toJS, web.BlobPropertyBag(type: 'image/heic'));
    final reader = web.FileReader();

    final completer = Completer<String>();
    reader.addEventListener(
        'load',
        (web.Event event) {
          completer.complete(reader.result as String);
        }.toJS);
    reader.readAsDataURL(blob);
    final dataUrl = await completer.future;

    final img = web.HTMLImageElement();
    img.src = dataUrl;

    final imgCompleter = Completer<void>();
    img.addEventListener(
        'load',
        (web.Event event) {
          imgCompleter.complete();
        }.toJS);
    await imgCompleter.future;

    final canvas = web.HTMLCanvasElement();
    canvas.width = img.width;
    canvas.height = img.height;

    final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
    ctx.drawImage(img, 0, 0);

    final jpegDataUrl = canvas.toDataURL('image/jpeg', 0.9.toJS);
    final base64 = jpegDataUrl.split(',').last;
    final bytes = base64Decode(base64);
    return bytes;
  }
}
