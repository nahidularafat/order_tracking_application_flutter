import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' show Location, LocationData, PermissionStatus;

import '../model/my_order.dart';

class DeliveryBoyController extends GetxController {
  TextEditingController orderIdController = TextEditingController();

  final Location location = Location();

  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '0';
  double customerLatitude = 37.7749;
  double customerLongitude = -122.4194;
  bool showDeliveryInfo = false;
  bool isDeliveryStarted = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference orderCollection;
  late final CollectionReference ordertrackingCollection;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('orders');
    ordertrackingCollection = firestore.collection('ordertracking');
    getLocationPermission();
  }

  Future<void> getOrderById() async {
    try {
      String orderId = orderIdController.text.trim();
      if (orderId.isEmpty) {
        Get.snackbar('Error', 'Order ID cannot be empty');
        return;
      }

      DocumentSnapshot doc = await orderCollection.doc(orderId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder order = MyOrder.fromJson(data);

        deliveryAddress = order.address ?? '';
        phoneNumber = order.phone ?? '';
        amountToCollect = order.amount.toString();
        customerLatitude = order.latitude ?? 0;
        customerLongitude = order.longitude ?? 0;
        showDeliveryInfo = true;
        update();
      } else {
        Get.snackbar('Error', 'Order not found');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> getLocationPermission() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          Get.snackbar('Error', 'Location services are disabled.');
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          Get.snackbar('Error', 'Location permission denied');
          return;
        }
      }
    } catch (e) {
      print('Error getting location permission: $e');
    }
  }

 void startDelivery() {
  final orderId = orderIdController.text.trim();

  if (orderId.isEmpty) {
    Get.snackbar('Error', 'Order ID is empty!');
    return;
  }

  if (!showDeliveryInfo) {
    Get.snackbar('Error', 'Please fetch order info first.');
    return;
  }

  // Start listening to location changes
  location.onLocationChanged.listen((LocationData currentLocation) {
    print('Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}');

    saveOrUpdateOrderLocation(
      orderId,
      currentLocation.latitude ?? 0,
      currentLocation.longitude ?? 0,
    );
  });

  location.enableBackgroundMode(enable: true);
  isDeliveryStarted = true;
  Get.snackbar('Success', 'Delivery tracking started.');
}


  Future<void> saveOrUpdateOrderLocation(String orderId, double latitude, double longitude) async {
    try {
      final DocumentReference docRef = ordertrackingCollection.doc(orderId);

      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude,
          });
        } else {
          transaction.set(docRef, {
            'orderId': orderId,
            'latitude': latitude,
            'longitude': longitude,
          });
        }
      });

      print('Location saved: $latitude, $longitude');
    } catch (e) {
      print('Error saving location: $e');
    }
  }
}
