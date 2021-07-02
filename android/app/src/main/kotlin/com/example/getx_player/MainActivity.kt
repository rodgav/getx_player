package com.example.getx_player

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.rsgmsolutions/player"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method.equals(("pip"))) {
                pipOn(result)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun pipOn(result: MethodChannel.Result) {
        val params = PictureInPictureParams.Builder()
                .build()
        activity.enterPictureInPictureMode(params)
        result.success(null)
    }
}
