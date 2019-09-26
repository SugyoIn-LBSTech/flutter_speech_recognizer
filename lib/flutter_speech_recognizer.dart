import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterSpeechRecognizer {
  static const MethodChannel methodChannel =
      const MethodChannel('net.lbstech.flutter_speech_recognizer');

  final Completer<String> transcription = Completer();

  final Function(String) onResult;

  FlutterSpeechRecognizer({this.onResult}) {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  Future setLocale(Locale locale) =>
      methodChannel.invokeMethod('setLocale', {'locale': locale.toString()});

  void listen() => methodChannel.invokeMethod('listen');

  void destroy() => methodChannel.invokeMethod('destory');

  void stop() => methodChannel.invokeMethod('stop');

  void cancel() => methodChannel.invokeMethod('cancel');

  Future _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onResult':
        String result = call.arguments;
        if (onResult != null) onResult(result);
        transcription.complete(result);
        break;
      default:
        throw ArgumentError.value(
            call.method, 'FlutterSpeechRecognizer', 'Unknowm method');
    }
  }
}
