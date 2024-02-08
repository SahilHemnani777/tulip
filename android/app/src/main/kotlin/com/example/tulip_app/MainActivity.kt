package com.example.tulip_app


import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // Your code goes here, such as functions or properties
}




//
//import android.content.Intent
//import android.content.pm.PackageManager
//import android.os.Bundle
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.plugins.GeneratedPluginRegistrant // Import this line
//import io.flutter.embedding.engine.FlutterEngine
//import androidx.core.app.ActivityCompat
//import androidx.core.content.ContextCompat
//import android.Manifest
//import android.content.pm.PackageManager.PERMISSION_GRANTED
//
//class MainActivity: FlutterActivity() {
//    val PERMISSIONS_REQUEST_CODE = 123
//    companion object {
//        private const val REQUEST_LOCATION_PERMISSION = 1
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine) // Register your plugins here
//        val serviceIntent = Intent(this, LocationTrackingService::class.java)
//        serviceIntent.putExtra("key","value")
//        startService(serviceIntent)
//        // Check and request location permission if necessary
//        checkAndRequestLocationPermission()
//    }
//
////    private fun checkAndRequestLocationPermission() {
////        println("Location Service Started inside for first")
////
////        val permission1 = Manifest.permission.ACCESS_FINE_LOCATION
////        val permission2 = Manifest.permission.ACCESS_BACKGROUND_LOCATION
////        val permission3 = Manifest.permission.ACCESS_COARSE_LOCATION
////        val permissionsToRequest = arrayOf(
////            Manifest.permission.ACCESS_COARSE_LOCATION,
////            Manifest.permission.ACCESS_BACKGROUND_LOCATION,
////            Manifest.permission.ACCESS_FINE_LOCATION
////        )
////        val permissionsNotGranted = mutableListOf<String>()
////        println("Location Service Started outside ")
////
////        for (permission in permissionsToRequest) {
////            println("Location Service Started inside for ")
////
////            if (ContextCompat.checkSelfPermission(this, permission) != PERMISSION_GRANTED) {
////
////                permissionsNotGranted.add(permission)
////            }
////        }
////        if (permissionsNotGranted.isNotEmpty()) {
////            println("Location Service Started isNotEmpty")
////
////            ActivityCompat.requestPermissions(
////                this,
////                permissionsNotGranted.toTypedArray(),
////                PERMISSIONS_REQUEST_CODE
////            )
////        } else {
////            println("Location Service Started inside for inside else ")
////
////            val serviceIntent = Intent(this, LocationTrackingService::class.java)
////            startService(serviceIntent)
////            // All permissions are already granted
////            // You can proceed with your logic here
////        }
////
////        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PERMISSION_GRANTED) {
////            println("Location Service Started inside for if check self inside")
////
////            ActivityCompat.requestPermissions(this, arrayOf(permission1,permission2,permission3), REQUEST_LOCATION_PERMISSION)
////        }
////        else{
////            println("Location Service Started inside for selfe else ")
////
////            val serviceIntent = Intent(this, LocationTrackingService::class.java)
////            startService(serviceIntent)
////        }
////    }
//
//    private fun checkAndRequestLocationPermission() {
//        println("123123111113")
//
//        val permission = Manifest.permission.ACCESS_FINE_LOCATION
//        if (ContextCompat.checkSelfPermission(this, permission) != PERMISSION_GRANTED) {
//            println("123123111113555")
//            ActivityCompat.requestPermissions(this, arrayOf(permission), REQUEST_LOCATION_PERMISSION)
//        }
//        else{
//            println("123123111113677")
//            val serviceIntent = Intent(this, LocationTrackingService::class.java)
//            serviceIntent.putExtra("key","value")
//            startService(serviceIntent)
//        }
//    }
//
//    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
//        when (requestCode) {
//            REQUEST_LOCATION_PERMISSION -> {
//                if (grantResults.isNotEmpty() && grantResults[0] == PERMISSION_GRANTED) {
//                    println("123123")
//                    // Permission granted, you can use the camera.
//                } else {
//                    println("123123123123")
//                    // Permission denied, handle this case (e.g., show a message to the user).
//                }
//            }
//            // Handle other permission requests if needed.
//        }
//    }
////    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
////        if (requestCode == PERMISSIONS_REQUEST_CODE) {
////            println("Location Service Started inside for onrequest")
////            for (i in grantResults.indices) {
////                println("Location Service Started inside for onrequest re for ")
////
////                if (grantResults[i] == PERMISSION_GRANTED) {
////                    // Permission granted for permissions[i]
////                } else {
////                    println("Declined kele re tuhje req")
////                    // Permission denied for permissions[i]
////                }
////            }
////        }
////    }
//}
