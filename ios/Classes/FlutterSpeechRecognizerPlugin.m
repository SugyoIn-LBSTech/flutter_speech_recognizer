#import "FlutterSpeechRecognizerPlugin.h"
#import <flutter_speech_recognizer/flutter_speech_recognizer-Swift.h>

@implementation FlutterSpeechRecognizerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSpeechRecognizerPlugin registerWithRegistrar:registrar];
}
@end
