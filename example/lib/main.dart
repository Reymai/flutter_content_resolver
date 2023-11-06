import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_content_resolver/flutter_content_resolver.dart';
import 'package:receive_intent/receive_intent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _content;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? content;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final initialIntent = await ReceiveIntent.getInitialIntent();
      if (initialIntent?.action == 'android.intent.action.SEND') {
        content = await FlutterContentResolver.resolveContent(
            initialIntent?.extra?['android.intent.extra.STREAM']);
        setState(() {
          _content = content;
        });
      }

      final intentStream = ReceiveIntent.receivedIntentStream;
      intentStream.listen((event) async {
        if (event!.action == 'android.intent.action.SEND') {
          content = await FlutterContentResolver.resolveContent(
              event.extra?['android.intent.extra.STREAM']);
        }
        setState(() {
          _content = content;
        });
      });
    } on PlatformException {
      content = 'Failed to get content.';
      setState(() {
        _content = content;
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: _content == null
              ? Text('Share content to see result')
              : Image.file(File(_content!)),
        ),
      ),
    );
  }
}
