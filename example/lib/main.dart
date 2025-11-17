import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:heic_to_jpeg/heic_to_jpeg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('heic_to_jpeg example')),
        body: Center(child: ExampleWidget()),
      ),
    );
  }
}

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  String _status = 'idle';

  Future<void> _pickAndConvert() async {
    // Example: load bytes however you get them. Here we just show flow.
    setState(() => _status = 'simulating...');
    // TODO: integrate file picker to get real Uint8List
    final Uint8List dummy = Uint8List.fromList([]);
    try {
      final result = await HeicToJpeg.convert(dummy);
      setState(() => _status = 'converted ${result.lengthInBytes} bytes');
    } catch (e) {
      setState(() => _status = 'error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_status),
        SizedBox(height: 16),
        ElevatedButton(onPressed: _pickAndConvert, child: Text('Convert')),
      ],
    );
  }
}
