import Flutter
import UIKit

public class SwiftFlutterSpeechRecognizerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_speech_recognizer", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSpeechRecognizerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
