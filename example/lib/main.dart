import 'package:flutter/material.dart';
import 'package:flutter_speech_recognizer/flutter_speech_recognizer.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterSpeechRecognizer _speechRecognizer;

  @override
  void initState() {
    super.initState();
    Locale locale = Localizations.localeOf(context);
    _speechRecognizer.setLocale(locale).catchError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
    _speechRecognizer = FlutterSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new IconButton(
              icon: const Icon(Icons.keyboard_voice),
              onPressed: iconButtonPressed,
              iconSize: 48.0,
              color: const Color(0xFF000000),
            )
          ]),
    );
  }

  void iconButtonPressed() => _speechRecognizer.listen();

  void _onResult(String result) {
    print(result);
  }
}
