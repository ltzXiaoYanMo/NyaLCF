package moe.xmcn.nyanana

import android.content.Context
import android.os.Build
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.util.*

class CopyElfs(private val ct: Context) {
    private val tag = "StackOF:"
    private val appFileDirectory: String
    private val executableFilePath: String
    private val assetManager = ct.assets
    private lateinit var resList: List<String>
    private var cpuType: String
    private val assetsFiles = arrayOf("frpc_injector")

    init {
        appFileDirectory = "/data/data/${ct.packageName}"
        executableFilePath = "$appFileDirectory"
        cpuType = Build.CPU_ABI
        try {
            resList = Arrays.asList(*ct.assets.list("$cpuType/"))
            Log.d(tag, "get assets list:" + resList.toString())
        } catch (e: IOException) {
            Log.e(tag, "error list assets folder:", e)
        }
    }

    fun resFileExist(filename: String): Boolean {
        val f = File("$executableFilePath/$filename")
        return f.exists()
    }

    private fun copyFile(input: InputStream, output: OutputStream) {
        try {
            val buffer = ByteArray(1024)
            var length: Int
            while (input.read(buffer).also { length = it } > 0) {
                output.write(buffer, 0, length)
            }
        } catch (e: IOException) {
            Log.e(tag, "failed to read/write asset file: ", e)
        }
    }

    private fun copyAssets(filename: String) {
        var input: InputStream? = null
        var output: OutputStream? = null
        Log.d(tag, "attempting to copy this file: $filename")
        try {
            input = assetManager.open("$cpuType/$filename")
            val outputFile = File(executableFilePath, filename)
            output = FileOutputStream(outputFile)
            copyFile(input, output)
            input.close()
            input = null
            output.flush()
            output.close()
            output = null
        } catch (e: IOException) {
            Log.e(tag, "failed to copy asset file: $filename", e)
        }
        Log.d(tag, "copy success: $filename")
    }

    fun copyAll2Data() {
        var i: Int
        val folder = File(executableFilePath)
        if (!folder.exists()) {
            folder.mkdir()
        }
        for (i in assetsFiles.indices) {
            if (!resFileExist(assetsFiles[i])) {
                copyAssets(assetsFiles[i])
                val execFile = File("$executableFilePath/${assetsFiles[i]}")
                execFile.setExecutable(true)
            }
        }
    }

    fun getExecutableFilePath(): String {
        return executableFilePath
    }
}
