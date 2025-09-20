package com.goods.goodealz


import io.flutter.embedding.android.FlutterActivity
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.map_api_key.flutter" // Unique Channel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->
            println("Hello, Kotlin!")
            if (call.method == "setGoogleMapKey") {
                val mapKey = call.argument<String>("mapKey")
                mapKey?.let { setMapKey(it) }
            } else {
                result.notImplemented()
            }
        }

    }

    private fun setMapKey(mapKey: String) {
        Log.d("Tag", "_setMapKey ==>${mapKey}")

        try {
            val applicationInfo =
                    packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
            applicationInfo.metaData.putString("com.google.android.geo.API_KEY", mapKey)
            println(applicationInfo.metaData.getString("com.google.android.geo.API_KEY"))
            println("done")
            println(packageName)
        } catch (e: PackageManager.NameNotFoundException) {
            println("Hello, Kotlin!errrrrorrrrr")
            e.printStackTrace()
        }
    }
}
