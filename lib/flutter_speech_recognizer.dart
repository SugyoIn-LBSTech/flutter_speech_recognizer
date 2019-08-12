import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterSpeechRecognizer {
  static const MethodChannel METHOD_CHANNEL =
      const MethodChannel('flutter_speech_recognizer');

  final Completer<String> transcription = Completer();

  final Function(String) onResult;

  FlutterSpeechRecognizer({this.onResult}) {
    METHOD_CHANNEL.setMethodCallHandler(_methodCallHandler);
  }

  Future setLocale(Locale locale) =>
      METHOD_CHANNEL.invokeMethod('setLocale', {'locale': locale.toString()});

  listen() => METHOD_CHANNEL.invokeMethod('listen');

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
