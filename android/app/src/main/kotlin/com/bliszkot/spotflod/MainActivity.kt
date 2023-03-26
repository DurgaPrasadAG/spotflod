package com.bliszkot.spotflod

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.task.core.BaseOptions
import org.tensorflow.lite.task.vision.classifier.Classifications
import org.tensorflow.lite.task.vision.classifier.ImageClassifier
import java.io.File
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val channelName = "classifier"
    private var imageClassifier: ImageClassifier? = null
    private val numberOfThreads = 1
    private val maxOutput = 1
    private val modelName = "model.tflite"
    private val threshold = 0.5F
    private val mean = 0.0F
    private val stdDev = 1.0F
    private val imageSize = 180

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "classifyImage") {
                    setupImageClassifier()

                    val path = call.argument<String>("path")
                    val res = classify(path!!)!![0].categories[0]
                    val label = res.label
                    val score = res.score
                    val index = res.index
                    val map = mapOf(
                        "label" to label,
                        "index" to index,
                        "score" to score
                    )

                    result.success(map).run {
                        imageClassifier = null
                    }
                }
                else if (call.method == "cacheDir") {
                    result.success(cacheDir.path)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun setupImageClassifier() {
        val optionsBuilder =
            ImageClassifier.ImageClassifierOptions.builder().setScoreThreshold(threshold)
                .setMaxResults(maxOutput)

        val baseOptionsBuilder = BaseOptions.builder().setNumThreads(numberOfThreads).useNnapi()

        optionsBuilder.setBaseOptions(baseOptionsBuilder.build())

        imageClassifier =
            ImageClassifier.createFromFileAndOptions(context, modelName, optionsBuilder.build())
    }

    private fun classify(path: String): MutableList<Classifications>? {
        val inputStream: InputStream = File(path).inputStream()
        val image: Bitmap = BitmapFactory.decodeStream(inputStream)

        if (imageClassifier == null) {
            setupImageClassifier()
        }

        val imageProcessor = ImageProcessor.Builder()
            .add(ResizeOp(imageSize, imageSize, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(mean, stdDev))
            .build()

        // Preprocess the image and convert it into a TensorImage for classification.
        val tensorImage = imageProcessor.process(TensorImage.fromBitmap(image))
        inputStream.close()
        // Classify
        return imageClassifier?.classify(tensorImage)
    }
}
