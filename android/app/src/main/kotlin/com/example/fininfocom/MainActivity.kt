package com.example.fininfocom

import android.app.Activity.RESULT_OK
import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val bluetoothChannel = "bluetooth_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine!!.dartExecutor!!.binaryMessenger, bluetoothChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "enableBluetooth") {
                    enableBluetooth(result)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun enableBluetooth(result: MethodChannel.Result) {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null) {
            if (!bluetoothAdapter.isEnabled) {
                val enableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                startActivityForResult(enableIntent, REQUEST_ENABLE_BLUETOOTH)
            } else {
                result.success(null)
            }
        } else {
            result.error("BLUETOOTH_NOT_SUPPORTED", "Bluetooth is not supported on this device", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_ENABLE_BLUETOOTH) {
            if (resultCode == RESULT_OK) {
                val channel = MethodChannel(flutterEngine!!.dartExecutor!!.binaryMessenger, bluetoothChannel)
                channel.invokeMethod("enableBluetooth", null)
            }
        }
    }

    companion object {
        private const val REQUEST_ENABLE_BLUETOOTH = 1
    }
}