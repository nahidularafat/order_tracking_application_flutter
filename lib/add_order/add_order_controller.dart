import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../model/my_order.dart';

class AddOrderController extends GetxController {
  TextEditingController orderIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  GoogleMapController? mapController;
  LatLng currentLocation = const LatLng(0, 0);
  LatLng selectedLocation = const LatLng(0, 0);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('orders');
    checkLocationPermissionAndGetLocation(); // 🔹 New line added
  }

  // 🔹 Step 1: Check permission and get current location
  Future<void> checkLocationPermissionAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Please enable GPS from settings.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location permission is permanently denied.');
        return;
      }
    }

    // 🔹 Get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentLocation = LatLng(position.latitude, position.longitude);
    selectedLocation = currentLocation;

    // 🔹 Move camera to current location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 15),
      );
    }

    update();
  }

  void addOrder(BuildContext context) {
    try {
      if (nameController.text.isEmpty || 
          orderIdController.text.isEmpty || 
          amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
        return;
      } else {
        DocumentReference doc = orderCollection.doc(orderIdController.text);
        MyOrder order = MyOrder(
          id: doc.id,
          name: nameController.text,
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
          phone: phoneController.text,
          address: addressController.text,
          amount: int.parse(amountController.text),
        );
        
        final orderJson = order.toJson();
        doc.set(orderJson); // push from here
        clearTextFields();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order added successfully")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add order: ${e.toString()}")));
    }
  }

  void clearTextFields() {
    orderIdController.clear();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    amountController.clear();
    update();
  }

  @override
  void onClose() {
    orderIdController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
