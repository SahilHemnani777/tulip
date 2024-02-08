//package com.example.tulip_app
//import android.app.Service
//import android.content.Intent
//import android.location.Location
//import android.os.IBinder
//import com.google.android.gms.location.FusedLocationProviderClient
//import com.google.android.gms.location.LocationCallback
//import com.google.android.gms.location.LocationRequest
//import com.google.android.gms.location.LocationResult
//import kotlinx.coroutines.GlobalScope
//import kotlinx.coroutines.delay
//import kotlinx.coroutines.launch
//
//class LocationTrackingService : Service() {
//
//    private lateinit var fusedLocationClient: FusedLocationProviderClient
//    private lateinit var locationCallback: LocationCallback
//
//    override fun onBind(intent: Intent?): IBinder? {
//        return null
//    }
//
//    override fun onCreate() {
//        super.onCreate()
//        fusedLocationClient = FusedLocationProviderClient(this)
//        startLocationUpdates()
//
//        // Inside your function or method
//        GlobalScope.launch {
//            while (true) {
//                // Code to run periodically
////                println("Code is running periodically")
//                fusedLocationClient.lastLocation
//                    .addOnSuccessListener { location: Location? ->
//                        // Handle the location here
//                        if (location != null) {
//                            val latitude = location.latitude
//                            val longitude = location.longitude
////                            println(longitude.toString())
////                            println(latitude.toString())
//                            // Use latitude and longitude as needed
//                        }
//                    }
//                    .addOnFailureListener { e ->
//                        // Handle any errors that may occur while getting the location
//                    }
//                // Delay for 5 seconds (5000 milliseconds)
//                delay(5000)
//            }
//        }
//    }
//
//    private fun startLocationUpdates() {
//        val locationRequest = LocationRequest()
//        locationRequest.interval = 5000 // Update interval in milliseconds (e.g., 30 seconds)
//        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
//
//        println("location Service Working in background Successfully")
//
//        locationCallback = object : LocationCallback() {
//            override fun onLocationResult(locationResult: LocationResult) {
//                locationResult.lastLocation?.let { location ->
//                    // Handle the location data (location.longitude, location.latitude)
//                    val longitude = location.longitude
//                    val latitude = location.latitude
////                    println(longitude.toString())
////                    println(latitude.toString())
//
//                    // Send the location data to your Flutter app using method channel or other means.
//                }
//            }
//        }
//
//        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, null)
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        stopLocationUpdates()
//        stopSelf()
//    }
//
//    private fun stopLocationUpdates() {
//        fusedLocationClient.removeLocationUpdates(locationCallback)
//    }
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        println("Location Service Started")
//            startLocationUpdates()
//        return START_STICKY
//    }
//}
