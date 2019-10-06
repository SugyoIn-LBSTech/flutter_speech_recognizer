import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterSpeechRecognizer {
  static const MethodChannel methodChannel =
  const MethodChannel('net.lbstech.flutter_speech_recognizer');

  final Completer<String> transcription = Completer();

  final Function(String) onResult;

  final void Function(SpeechRecognizerException) onError;

  FlutterSpeechRecognizer({this.onResult, this.onError}) {
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
      case 'onError':
        int errorCode = call.arguments['code'];
        String message = call.arguments['message'];
        throw SpeechRecognizerException(errorCode, message);
      default:
        throw ArgumentError.value(
            call.method, 'FlutterSpeechRecognizer', 'Unknowm method');
    }
  }
}

class SpeechRecognizerException implements Exception {
  final int code;
  final String message;

  SpeechRecognizerException(this.code, this.message);

  @override
  String toString() =>
      'Error on FlutterSpeechRecogizer. code: $code, message: $message';
}
