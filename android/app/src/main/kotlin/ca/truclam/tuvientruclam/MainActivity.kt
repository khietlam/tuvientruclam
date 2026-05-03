package ca.truclam.tuvientruclam

import android.hardware.Camera
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.util.Log
import android.util.Size
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "ca.truclam.tuvientruclam/camera_diag"
        private const val TAG = "CameraDiag"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "dump" -> {
                        try {
                            val output = dumpCameras()
                            Log.i(TAG, output)
                            result.success(output)
                        } catch (t: Throwable) {
                            Log.e(TAG, "dump failed", t)
                            result.error("DUMP_FAILED", t.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun dumpCameras(): String {
        val sb = StringBuilder()
        sb.appendLine("=== Camera2 API ===")
        val mgr = getSystemService(CAMERA_SERVICE) as CameraManager
        val ids = mgr.cameraIdList
        sb.appendLine("Camera IDs: ${ids.toList()}")
        for (id in ids) {
            sb.appendLine("--- id=$id ---")
            val c = mgr.getCameraCharacteristics(id)
            val facing = when (c.get(CameraCharacteristics.LENS_FACING)) {
                CameraCharacteristics.LENS_FACING_FRONT -> "FRONT"
                CameraCharacteristics.LENS_FACING_BACK -> "BACK"
                CameraCharacteristics.LENS_FACING_EXTERNAL -> "EXTERNAL"
                else -> "UNKNOWN"
            }
            sb.appendLine("facing: $facing")
            sb.appendLine("sensorOrientation: ${c.get(CameraCharacteristics.SENSOR_ORIENTATION)}")
            val hwLevel = c.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)
            val hwLevelStr = when (hwLevel) {
                CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY -> "LEGACY"
                CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LIMITED -> "LIMITED"
                CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_FULL -> "FULL"
                CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_3 -> "LEVEL_3"
                CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_EXTERNAL -> "EXTERNAL"
                else -> "UNKNOWN($hwLevel)"
            }
            sb.appendLine("hardwareLevel: $hwLevelStr")
            val activeArray = c.get(CameraCharacteristics.SENSOR_INFO_ACTIVE_ARRAY_SIZE)
            sb.appendLine("activeArray: $activeArray")
            val pixelArray = c.get(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)
            sb.appendLine("pixelArray: $pixelArray")
            val map = c.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            if (map != null) {
                val outputSizes: Array<Size>? = map.getOutputSizes(android.graphics.ImageFormat.YUV_420_888)
                sb.appendLine("YUV_420_888 sizes: ${outputSizes?.joinToString { "${it.width}x${it.height}" }}")
                val previewSizes: Array<Size>? = map.getOutputSizes(android.graphics.SurfaceTexture::class.java)
                sb.appendLine("SurfaceTexture sizes: ${previewSizes?.joinToString { "${it.width}x${it.height}" }}")
            }
        }

        sb.appendLine()
        sb.appendLine("=== Camera1 API (legacy) ===")
        val n = Camera.getNumberOfCameras()
        sb.appendLine("Camera count: $n")
        for (i in 0 until n) {
            val info = Camera.CameraInfo()
            Camera.getCameraInfo(i, info)
            val facing = when (info.facing) {
                Camera.CameraInfo.CAMERA_FACING_FRONT -> "FRONT"
                Camera.CameraInfo.CAMERA_FACING_BACK -> "BACK"
                else -> "UNKNOWN"
            }
            sb.appendLine("--- id=$i facing=$facing orientation=${info.orientation} ---")
            var cam: Camera? = null
            try {
                cam = Camera.open(i)
                val params = cam.parameters
                sb.appendLine("preview-size: ${params.previewSize.width}x${params.previewSize.height}")
                sb.appendLine("preview-sizes: ${params.supportedPreviewSizes.joinToString { "${it.width}x${it.height}" }}")
                sb.appendLine("picture-sizes: ${params.supportedPictureSizes.joinToString { "${it.width}x${it.height}" }}")
                sb.appendLine("focus-modes: ${params.supportedFocusModes}")
                sb.appendLine("flash-modes: ${params.supportedFlashModes}")
            } catch (t: Throwable) {
                sb.appendLine("open() failed: ${t.message}")
            } finally {
                cam?.release()
            }
        }
        return sb.toString()
    }
}