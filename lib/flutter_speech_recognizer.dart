import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterSpeechRecognizer {
  static const MethodChannel METHOD_CHANNEL =
      const MethodChannel('flutter_speech_recognizer');

  final Function(String) onResult;

  FlutterSpeechRecognizer(this.onResult) {
    METHOD_CHANNEL.setMethodCallHandler(_methodCallHandler);
  }

  Future setLocale(Locale locale) =>
      METHOD_CHANNEL.invokeMethod('setLocale', {'locale': locale.toString()});

  listen() => METHOD_CHANNEL.invokeMethod('listen');

  Future _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onResult':
        onResult(call.arguments);
        break;
      default:
        throw ArgumentError.value(
            call.method, 'FlutterSpeechRecognizer', 'Unknowm method');
    }
  }
}
