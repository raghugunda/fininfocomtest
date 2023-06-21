package com.example.fininfocom

import android.Manifest
import android.app.Activity.RESULT_OK
import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity() {


    private val channel = "bluetooth_channel"
    private val requestEnableBluetooth = 100

    private lateinit var permissionResult: MethodChannel.Result
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor!!.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableBluetooth" -> {
                        if (ContextCompat.checkSelfPermission(
                                this,
                                Manifest.permission.BLUETOOTH_CONNECT
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                                ActivityCompat.requestPermissions(
                                    this,
                                    arrayOf(Manifest.permission.BLUETOOTH_CONNECT),
                                    1
                                )
                            }

                        }
                        enableBluetooth(result)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }




    private fun enableBluetooth(result: MethodChannel.Result) {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null) {
            if (!bluetoothAdapter.isEnabled) {
                val enableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                startActivityForResult(enableIntent, requestEnableBluetooth)
            } else {
                result.success(null)
            }
        } else {
            result.error("BLUETOOTH_NOT_SUPPORTED", "Bluetooth is not supported on this device", null)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        if (requestCode == requestEnableBluetooth) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
                if (bluetoothAdapter != null) {
                    if (!bluetoothAdapter.isEnabled) {
                        val enableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                        startActivityForResult(enableIntent, requestEnableBluetooth)
                    } else {

                    }
                }
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == requestEnableBluetooth) {
            if (resultCode == RESULT_OK) {
                val channel = MethodChannel(flutterEngine?.dartExecutor!!.binaryMessenger, channel)
                channel.invokeMethod("enableBluetooth", null)
            }
        }
    }
}