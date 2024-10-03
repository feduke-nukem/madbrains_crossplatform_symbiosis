package com.example.coloringpages

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.core.content.FileProvider
import coil.compose.AsyncImage
import com.example.coloringapi.coloring_api.ColoringSdk
import com.example.coloringpages.ui.theme.ColoringPagesTheme
import com.example.coloringsdk.api.ColoringHostApi
import com.example.coloringsdk.api.ColoringSdkButtonTheme
import com.example.coloringsdk.api.ColoringSdkConfiguration
import com.example.coloringsdk.api.ColoringSdkLocalizations
import com.example.coloringsdk.api.ColoringSdkTheme
import java.io.File
import java.util.HashMap

private const val attackOnTitan = "attack_on_titan.webp"
private const val chadShrek = "chad_shrek.webp"
private const val hellBoy = "hell_boy.webp"
private const val spawn = "spawn.webp"
private const val spiderMan = "spider_man.webp"

class MainActivity : ComponentActivity() {
    private val sessions = HashMap<String, String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            ColoringPagesTheme {
                MainScreen()
            }
        }
    }

    @Composable
    private fun MainScreen() {
        Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
            Box(modifier = Modifier.padding(innerPadding)) {
                var coloredImageBitmap by remember { mutableStateOf<ImageBitmap?>(null) }

                ImagesPreview { result ->
                    coloredImageBitmap = result
                }

                coloredImageBitmap?.let {
                    ShowImageDialog(
                        imageBitmap = it,
                        onDismiss = { coloredImageBitmap = null },
                        onShareClick = {
                            handleShareImage(it)
                            coloredImageBitmap = null
                        }
                    )
                }
            }
        }
    }

    @Composable
    private fun LocalImagesList(onSelected: (String) -> Unit) {
        val images = listOf(
            attackOnTitan,
            chadShrek,
            hellBoy,
            spawn,
            spiderMan,
        )

        LazyColumn(modifier = Modifier.fillMaxSize()) {
            items(images.size) {
                val assetName = images[it]
                AsyncImage(
                    model = "file:///android_asset/$assetName",
                    contentDescription = null,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp)
                        .clickable { onSelected(assetName) },
                    contentScale = ContentScale.Fit
                )
            }
        }
    }

    @Composable
    private fun ImagesPreview(onImage: (ImageBitmap) -> Unit) {
        Column(modifier = Modifier.fillMaxSize()) {
            Text(text = "Select and color!", modifier = Modifier.padding(16.dp))

            LocalImagesList { assetName ->
                val inputStream = assets.open(assetName)

                try {
                    ColoringSdk.colorImage(
                        applicationContext,
                        HostHandler(
                            onExit = {
                                sessions[assetName] = it
                            },
                            onResult = { result ->
                                val bitmap = BitmapFactory.decodeByteArray(result, 0, result.size)
                                onImage(bitmap.asImageBitmap())
                                sessions.remove(assetName)
                            }
                        ),
                        ColoringSdkConfiguration(
                            image = inputStream.readBytes(),
                            colorPresets = listOf(
                                "#ffffff",
                                "#030303",
                                "#5c4ede",
                                "#1c1273",
                                "#dff291",
                                "#f59e14",
                                "#ff30c1",
                            ),
                            initialColor = when (assetName) {
                                attackOnTitan -> "#c97979"
                                chadShrek -> "#8cc979"
                                hellBoy -> "#a30a0a"
                                spawn -> "#000000"
                                spiderMan -> "#ff0000"
                                else -> "#1900ff"
                            },
                            localizations = ColoringSdkLocalizations(
                                applicationTitle = "Coloring pages",
                                submitTooltip = "Submit and share!",
                                pickColorTooltip = "Pick your very own color!",
                                colorPickerTitle = "Pick your color!",
                                colorPickerPresetsTitle = "Available color presets",
                                screenTitle = "Color this one!",
                            ),
                            session = sessions[assetName],
                            theme = ColoringSdkTheme(
                                surface = "#80000000",
                                onSurface = "#cfcccc",
                                surfaceContainer = "#333030",
                                secondary = "#10eb1b",
                                buttonTheme = ColoringSdkButtonTheme(
                                    background = "#333030",
                                    foreground = "#cfcccc",
                                )
                            )
                        ),
                    )
                } catch (e: Exception) {
                    print(e)
                }

            }
        }
    }

    private fun handleShareImage(imageBitmap: ImageBitmap) {
        val file = saveBitmapToFile(applicationContext, imageBitmap.asAndroidBitmap())
        shareImage(applicationContext, file)
    }
}

@Composable
fun ShowImageDialog(
    imageBitmap: ImageBitmap,
    onDismiss: () -> Unit,
    onShareClick: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x80000000))
    ) {
        Dialog(onDismissRequest = onDismiss) {
            Box(
                modifier = Modifier
                    .padding(16.dp)
                    .background(Color.White, shape = RoundedCornerShape(12.dp))
                    .padding(16.dp)
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Image(
                        bitmap = imageBitmap,
                        contentDescription = "Preview Image",
                        modifier = Modifier.fillMaxWidth(),
                        contentScale = ContentScale.Fit
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    ButtonRow(onDismiss = onDismiss, onShareClick = onShareClick)
                }
            }
        }
    }
}

@Composable
private fun ButtonRow(onDismiss: () -> Unit, onShareClick: () -> Unit) {
    Row(
        horizontalArrangement = Arrangement.SpaceBetween,
        modifier = Modifier.fillMaxWidth()
    ) {
        Button(onClick = onDismiss) {
            Text("Close")
        }
        Button(onClick = onShareClick) {
            Text("Share")
        }
    }
}

private fun saveBitmapToFile(context: Context, bitmap: Bitmap): File {
    val file = File(context.cacheDir, "shared_image.png")
    file.outputStream().use {
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
    }
    return file
}

private fun shareImage(context: Context, imageFile: File) {
    val uri = FileProvider.getUriForFile(
        context,
        "${context.packageName}.provider",
        imageFile
    )

    val intent = Intent(Intent.ACTION_SEND).apply {
        type = "image/*"
        putExtra(Intent.EXTRA_STREAM, uri)
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

    }

    context.startActivity(
        Intent.createChooser(intent, "Share Image").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    )
}

class HostHandler(
    private val onExit: (String) -> Unit,
    private val onResult: (ByteArray) -> Unit

) : ColoringHostApi {
    override fun onExitWithoutSubmit(session: String) = onExit(session)

    override fun onColoringSubmit(image: ByteArray) = onResult(image)
}
