import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../model/my_order.dart';

class LiveTrackingController extends GetxController {
  // Controller state
  String orderId = '0000';
  late MyOrder myOrder;

  LatLng destination = const LatLng(0.0, 0.0);
  LatLng deliveryBoyLocation = const LatLng(0.0, 0.0);
  GoogleMapController? mapController;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  );

  double remainingDistance = 0.0;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference orderTrackingCollection =
      FirebaseFirestore.instance.collection('ordertracking');

  @override
  void onInit() {
    addCustomMarker();
    super.onInit();
  }

  // ✅ Called from UI with order data
  void initialize(MyOrder order) {
    myOrder = order;
    orderId = order.id ?? '0000';

    // ✅ Step 1: Set destination from order's coordinates
    double lat = order.latitude ?? 0.0;
    double lng = order.longitude ?? 0.0;
    destination = LatLng(lat, lng);

    print('🎯 Destination set to: $destination');

    // ✅ Step 2: Only start tracking if destination is valid
    if (lat != 0.0 && lng != 0.0) {
      startTracking(orderId);
    } else {
      print('⚠️ Invalid destination coordinates!');
    }

    update(); // Refresh UI
  }

  void startTracking(String orderId) {
    try {
      orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          double latitude = trackingData['latitude'];
          double longitude = trackingData['longitude'];

          print('📍 Fetched Delivery Location: $latitude, $longitude');

          updateUIWithLocation(latitude, longitude);
        } else {
          print('⚠️ No tracking data for order: $orderId');
        }
      });
    } catch (e) {
      print('🔥 Error in tracking: $e');
    }
  }

  void updateUIWithLocation(double latitude, double longitude) {
    deliveryBoyLocation = LatLng(latitude, longitude);
    print('📍 Updated DeliveryBoyLocation: $deliveryBoyLocation');
    print('🎯 Destination: $destination');

    if (destination.latitude != 0.0 && destination.longitude != 0.0) {
      double distance = Geolocator.distanceBetween(
        deliveryBoyLocation.latitude,
        deliveryBoyLocation.longitude,
        destination.latitude,
        destination.longitude,
      );
      remainingDistance = distance / 1000; // in km
      print('📏 Remaining Distance: $remainingDistance km');
    } else {
      print('⚠️ Destination not set, skipping distance calculation.');
    }

    mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
    update();
  }

  void addCustomMarker() {
    markerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    );
    update();
  }
}
