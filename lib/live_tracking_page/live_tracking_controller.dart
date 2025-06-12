import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import '../model/my_order.dart';

class LiveTrackingController extends GetxController {
  // Controller state
  String orderId = '0000';
  late MyOrder myOrder;
  LatLng destination = const LatLng(10.2929726, 76.1645936);
  LatLng deliveryBoyLocation = const LatLng(10.3225, 76.1526);
  GoogleMapController? mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  double remainingDistance = 0.0;
  
  // Services
  final Location location = Location();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    orderTrackingCollection = firestore.collection('orderTracking');
    addCustomMarker();
    super.onInit();
  }

  // ===== DISTANCE CALCULATION (FROM YOUR IMAGE) =====
  void calculateRemainingDistance() {
    double distance = Geolocator.distanceBetween(
      deliveryBoyLocation.latitude,
      deliveryBoyLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    double distanceInKm = distance / 1000;
    remainingDistance = distanceInKm;
    print("Remaining Distance: $distanceInKm kilometers");
    update();
  }

  // ===== ORDER TRACKING =====
  void startTracking(String orderId) {
    try {
      orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          updateUIWithLocation(
            trackingData['latitude'], 
            trackingData['longitude']
          );
          calculateRemainingDistance();
        } else {
          print('No tracking data for order: $orderId');
        }
      });
    } catch (e) {
      print('Tracking error: $e');
    }
  }

  // ===== LOCATION UPDATES =====
  void updateUIWithLocation(double latitude, double longitude) {
    deliveryBoyLocation = LatLng(latitude, longitude);
    mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
    calculateRemainingDistance();

  }

  void updateCurrentLocation(double latitude, double longitude) {
    destination = LatLng(latitude, longitude);
    update();
  }

  // ===== CUSTOM MARKER =====
  void addCustomMarker() {
    ImageConfiguration configuration = 
        const ImageConfiguration(size: Size(0, 0), devicePixelRatio: 1);

    BitmapDescriptor.fromAssetImage(configuration, 'assets/images/root_icon.png')
        .then((value) {
      markerIcon = value;
      update();
    });
  }
}