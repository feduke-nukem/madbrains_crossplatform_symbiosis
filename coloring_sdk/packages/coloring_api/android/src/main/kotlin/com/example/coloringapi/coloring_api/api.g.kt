// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

package com.example.coloringsdk.api

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

private fun createConnectionError(channelName: String): FlutterError {
  return FlutterError("channel-error",  "Unable to establish connection on channel: '$channelName'.", "")}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class ColoringSdkConfiguration (
  val image: ByteArray,
  /** Hex format. */
  val initialColor: String,
  /**
   * Json format.
   *
   * Only could be used from previously saved session [HostApi.onExitWithoutSubmit]
   *
   * or from [FlutterColoringApi.getSession].
   */
  val session: String? = null,
  /** Hex format. */
  val colorPresets: List<String>,
  val localizations: ColoringSdkLocalizations,
  val theme: ColoringSdkTheme
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): ColoringSdkConfiguration {
      val image = pigeonVar_list[0] as ByteArray
      val initialColor = pigeonVar_list[1] as String
      val session = pigeonVar_list[2] as String?
      val colorPresets = pigeonVar_list[3] as List<String>
      val localizations = pigeonVar_list[4] as ColoringSdkLocalizations
      val theme = pigeonVar_list[5] as ColoringSdkTheme
      return ColoringSdkConfiguration(image, initialColor, session, colorPresets, localizations, theme)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      image,
      initialColor,
      session,
      colorPresets,
      localizations,
      theme,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class ColoringSdkLocalizations (
  val applicationTitle: String,
  val submitTooltip: String,
  val pickColorTooltip: String,
  val colorPickerTitle: String,
  val colorPickerPresetsTitle: String,
  val screenTitle: String
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): ColoringSdkLocalizations {
      val applicationTitle = pigeonVar_list[0] as String
      val submitTooltip = pigeonVar_list[1] as String
      val pickColorTooltip = pigeonVar_list[2] as String
      val colorPickerTitle = pigeonVar_list[3] as String
      val colorPickerPresetsTitle = pigeonVar_list[4] as String
      val screenTitle = pigeonVar_list[5] as String
      return ColoringSdkLocalizations(applicationTitle, submitTooltip, pickColorTooltip, colorPickerTitle, colorPickerPresetsTitle, screenTitle)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      applicationTitle,
      submitTooltip,
      pickColorTooltip,
      colorPickerTitle,
      colorPickerPresetsTitle,
      screenTitle,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class ColoringSdkTheme (
  /** Hex format. */
  val surface: String,
  /** Hex format. */
  val onSurface: String,
  /** Hex format. */
  val surfaceContainer: String,
  /** Hex format. */
  val secondary: String,
  val buttonTheme: ColoringSdkButtonTheme
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): ColoringSdkTheme {
      val surface = pigeonVar_list[0] as String
      val onSurface = pigeonVar_list[1] as String
      val surfaceContainer = pigeonVar_list[2] as String
      val secondary = pigeonVar_list[3] as String
      val buttonTheme = pigeonVar_list[4] as ColoringSdkButtonTheme
      return ColoringSdkTheme(surface, onSurface, surfaceContainer, secondary, buttonTheme)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      surface,
      onSurface,
      surfaceContainer,
      secondary,
      buttonTheme,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class ColoringSdkButtonTheme (
  /** Hex format. */
  val background: String,
  /** Hex format. */
  val foreground: String
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): ColoringSdkButtonTheme {
      val background = pigeonVar_list[0] as String
      val foreground = pigeonVar_list[1] as String
      return ColoringSdkButtonTheme(background, foreground)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      background,
      foreground,
    )
  }
}
private open class apiPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ColoringSdkConfiguration.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ColoringSdkLocalizations.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ColoringSdkTheme.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ColoringSdkButtonTheme.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is ColoringSdkConfiguration -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is ColoringSdkLocalizations -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is ColoringSdkTheme -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is ColoringSdkButtonTheme -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
class FlutterColoringApi(private val binaryMessenger: BinaryMessenger, private val messageChannelSuffix: String = "") {
  companion object {
    /** The codec used by FlutterColoringApi. */
    val codec: MessageCodec<Any?> by lazy {
      apiPigeonCodec()
    }
  }
  fun onConfigurationProvided(configurationArg: ColoringSdkConfiguration, callback: (Result<Unit>) -> Unit)
{
    val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
    val channelName = "dev.flutter.pigeon.coloring_api.FlutterColoringApi.onConfigurationProvided$separatedMessageChannelSuffix"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(configurationArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
}
/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface ColoringHostApi {
  /** Json format. */
  fun onExitWithoutSubmit(session: String)
  fun onColoringSubmit(image: ByteArray)

  companion object {
    /** The codec used by ColoringHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      apiPigeonCodec()
    }
    /** Sets up an instance of `ColoringHostApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: ColoringHostApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.coloring_api.ColoringHostApi.onExitWithoutSubmit$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val sessionArg = args[0] as String
            val wrapped: List<Any?> = try {
              api.onExitWithoutSubmit(sessionArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.coloring_api.ColoringHostApi.onColoringSubmit$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val imageArg = args[0] as ByteArray
            val wrapped: List<Any?> = try {
              api.onColoringSubmit(imageArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
