package com.example.coloringapi.coloring_api

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import androidx.annotation.Keep
import com.example.coloringsdk.api.ColoringHostApi
import com.example.coloringsdk.api.ColoringSdkConfiguration
import com.example.coloringsdk.api.FlutterColoringApi
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import java.lang.reflect.Field

private const val FLUTTER_ENGINE_KEY = "engine"

@Keep
object ColoringSdk {
    fun colorImage(
        context: Context,
        host: ColoringHostApi,
        configuration: ColoringSdkConfiguration
    ) {
        configuration.validate()
        createEngine(context).let {
            ColoringHostApi.setUp(it.dartExecutor, host)
            FlutterColoringApi(it.dartExecutor).provideConfiguration(configuration) {}
        }
        val intent = FlutterActivity.CachedEngineIntentBuilder(ColoringActivity::class.java, FLUTTER_ENGINE_KEY)
            .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
            .build(context)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    private fun createEngine(context: Context): FlutterEngine {
        val cache = FlutterEngineCache.getInstance()
        val cachedEngine = cache.get(FLUTTER_ENGINE_KEY)

        if (cachedEngine != null) {
            return cachedEngine
        }

        val engine = FlutterEngine(context)
        cache.put(FLUTTER_ENGINE_KEY, engine)

        val loader = FlutterInjector.instance().flutterLoader()
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(
                loader.findAppBundlePath(),
                "colorImage",
            ),
        )

        return engine
    }
}


internal class ColoringActivity : FlutterActivity()

private fun ColoringSdkConfiguration.validate() {
    if (!isValidHexColor(initialColor)) {
        throw IllegalArgumentException("invalid initialColor: $initialColor")
    }

    for (preset in colorPresets) {
        if (isValidHexColor(preset)) continue

        throw IllegalArgumentException("invalid preset: $preset")
    }

    image.let {
        if (!isValidImage(it)) {
            throw IllegalArgumentException("invalid image: $it")
        }
    }


    val invalidColors = theme.validateHexColors()

    if (invalidColors.isNotEmpty()) {
        throw IllegalArgumentException("Invalid theme colors: ${invalidColors.joinToString(", ")}")
    }

}

private fun isValidHexColor(color: String): Boolean {
    // Regular expression to match strings that start with '#' and contain 3, 6, or 8 hex digits
    val hexColorPattern = "^#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$".toRegex()
    return color.matches(hexColorPattern)
}

private fun isValidImage(byteArray: ByteArray): Boolean =
    BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size) != null

fun Any.validateHexColors(prefix: String = ""): List<String> {
    val invalidFields = mutableListOf<String>()

    this::class.java.declaredFields.forEach { field ->
        field.isAccessible = true // Allow access to private fields

        when {
            field.type == String::class.java -> {
                val value = field.get(this) as? String
                if (value != null && !isValidHexColor(value)) {
                    invalidFields.add("$prefix${field.name}")
                }
            }
            // Check for nested custom types
            !field.type.isPrimitive && !field.type.name.startsWith("java.") -> {
                field.get(this)?.let { nestedObject ->
                    invalidFields.addAll(nestedObject.validateHexColors("$prefix${field.name}."))
                }
            }
        }
    }

    return invalidFields
}