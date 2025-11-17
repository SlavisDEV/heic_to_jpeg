import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'heic_to_jpeg.dart';

// JS interop for heic2any library
@JS('heic2any')
external JSPromise _heic2anyJS(JSObject options);

class HeicToJpegWeb {
  static void registerWith(Registrar registrar) {
    HeicToJpeg.registerWeb(_convertWeb);
  }

  static Future<Uint8List> _convertWeb(Uint8List heicBytes) async {
    try {
      web.console.log('Starting HEIC conversion...'.toJS);

      // Create blob from HEIC bytes
      final heicBlob = web.Blob(
        [heicBytes.toJS].toJS,
        web.BlobPropertyBag(type: 'image/heic'),
      );

      web.console.log('HEIC blob created, size: ${heicBlob.size}'.toJS);

      // Use heic2any to convert HEIC to JPEG
      final options = {
        'blob': heicBlob,
        'toType': 'image/jpeg',
        'quality': 0.9,
      }.jsify() as JSObject;

      web.console.log('Calling heic2any...'.toJS);
      final jpegBlobPromise = _heic2anyJS(options);
      final jpegBlob = (await jpegBlobPromise.toDart) as web.Blob;

      web.console.log('Conversion successful, JPEG blob size: ${jpegBlob.size}'.toJS);

      // Read blob as bytes
      final reader = web.FileReader();
      final completer = Completer<Uint8List>();

      reader.addEventListener(
        'load',
        (web.Event event) {
          final arrayBuffer = reader.result as JSArrayBuffer;
          final uint8List = arrayBuffer.toDart.asUint8List();
          completer.complete(uint8List);
        }.toJS,
      );

      reader.addEventListener(
        'error',
        (web.Event event) {
          completer.completeError('Failed to read JPEG blob');
        }.toJS,
      );

      reader.readAsArrayBuffer(jpegBlob);
      final jpegBytes = await completer.future;

      web.console.log('JPEG bytes ready: ${jpegBytes.length} bytes'.toJS);
      return jpegBytes;
    } catch (e) {
      web.console.error('HEIC conversion error: $e'.toJS);
      throw Exception('Failed to convert HEIC to JPEG: $e');
    }
  }
}
