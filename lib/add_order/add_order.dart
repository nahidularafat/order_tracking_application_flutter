import 'package:car_track/order_list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'add_order_controller.dart';

class AddOrderPage extends StatelessWidget {
  const AddOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
      init: AddOrderController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Details'),
            actions: [
              IconButton(
                onPressed: () => Get.to(const OrdersListPage()),
                icon: const Icon(Icons.list),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.map_outlined),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: controller.orderIdController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Student Phone',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller.addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller.amountController,
                  decoration: const InputDecoration(
                    labelText: 'Bill Amount',
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                    onTap: (latLng) {
                      controller.selectedLocation = latLng;
                      controller.update();
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: controller.selectedLocation,
                        infoWindow: InfoWindow(
                          title: 'Selected Location',
                          snippet: 'Lat: ${controller.selectedLocation.latitude}, Lng: ${controller.selectedLocation.longitude}',
                        ),
                      ),
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    //await Firebase.initializeApp();
                    controller.addOrder(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}