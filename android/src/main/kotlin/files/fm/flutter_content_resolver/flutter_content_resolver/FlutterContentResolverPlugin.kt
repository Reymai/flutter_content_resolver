package files.fm.flutter_content_resolver.flutter_content_resolver

import android.content.Context
import android.net.Uri
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class FlutterContentResolverPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_content_resolver")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "resolveContent") {
      val uri = Uri.parse(call.arguments as String)
      val filePath = resolveContent(uri)
      result.success(filePath)
    } else {
      result.notImplemented()
    }
  }

  private fun resolveContent(uri: Uri): String? {
    val tempFile = copyContentToTempFile(uri)
    return tempFile?.absolutePath
  }

  private fun copyContentToTempFile(uri: Uri): File? {
    val inputStream = context.contentResolver.openInputStream(uri)
    val originalFilename = getOriginalFilenameFromContentUri(uri)
    val tempDir = context.cacheDir
    val tempFile = if (originalFilename != null)  File(tempDir, originalFilename) else File.createTempFile("", null, tempDir)
    val outputStream = FileOutputStream(tempFile)
    inputStream?.copyTo(outputStream)
    inputStream?.close()
    outputStream.close()
    return tempFile
  }

  private fun getOriginalFilenameFromContentUri(uri: Uri): String? {
    val cursor = context.contentResolver.query(uri, null, null, null, null)
    cursor?.use {
      val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
      it.moveToFirst()
      return it.getString(nameIndex)
    }
    return null
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

