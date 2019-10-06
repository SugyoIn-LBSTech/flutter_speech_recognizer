package net.lbstech.flutter_speech_recognizer

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class FlutterSpeechRecognizerPlugin(
        context: Context,
        private val mMethodChannel: MethodChannel) : MethodCallHandler, RecognitionListener {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "net.lbstech.flutter_speech_recognizer")
            channel.setMethodCallHandler(FlutterSpeechRecognizerPlugin(registrar.context(), channel))
        }
    }

    private enum class Error(val code: Int) {
        ArgumentsIsNull(0)
    }

    private val mSpeechRecognizer = SpeechRecognizer.createSpeechRecognizer(context).also { speechRecognizer ->
        speechRecognizer.setRecognitionListener(this)
    }

    private val mRecognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
        putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setLocale" -> {
                if (call.hasArgument("locale")) {
                    mRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, call.argument<String>("locale"))
                    result.success(null)
                } else sendErrorWithResult(result, Error.ArgumentsIsNull)
            }
            "listen" -> mSpeechRecognizer.startListening(mRecognizerIntent)
            "stop" -> mSpeechRecognizer.stopListening()
            "cancel" -> mSpeechRecognizer.cancel()
            "destroy" -> mSpeechRecognizer.run {
                cancel()
                destroy()
            }
            else -> result.notImplemented()
        }
    }

    override fun onReadyForSpeech(p0: Bundle?) {}

    override fun onRmsChanged(p0: Float) {}

    override fun onBufferReceived(p0: ByteArray?) {}

    override fun onPartialResults(p0: Bundle?) {}

    override fun onEvent(p0: Int, p1: Bundle?) {}

    override fun onBeginningOfSpeech() {}

    override fun onEndOfSpeech() {}

    override fun onError(errorCode: Int) {
        when (errorCode) {
            1 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_NETWORK_TIMEOUT"))
            2 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_NETWORK"))
            3 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_SERVER"))
            4 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_CLIENT"))
            5 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_CLIENT"))
            6 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_SPEECH_TIMEOUT"))
            7 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_NO_MATCH"))
            8 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_RECOGNIZER_BUSY"))
            9 -> mMethodChannel.invokeMethod("onError", mapOf("code" to errorCode, "message" to "ERROR_INSUFFICIENT_PERMISSIONS"))
        }
    }

    override fun onResults(bundle: Bundle?) {
        bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.let { results ->
            mMethodChannel.invokeMethod("onResult", results[0])
        }
    }

    private fun sendErrorWithResult(result: Result, error: Error, detail: String? = null) =
            result.error(error.code.toString(), error.toString(), detail)
}
