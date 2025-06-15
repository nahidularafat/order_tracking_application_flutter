import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../model/my_order.dart';
import 'live_tracking_controller.dart';

class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arg = Get.arguments;
    MyOrder order = arg['order'];

    return GetBuilder<LiveTrackingController>(
      init: LiveTrackingController()..initialize(order),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Order Tracking')),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                onMapCreated: (mpCtrl) {
                  controller.mapController = mpCtrl;
                },
                initialCameraPosition: CameraPosition(
                  target: controller.deliveryBoyLocation,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('deliveryBoy'),
                    position: controller.deliveryBoyLocation,
                    icon: controller.markerIcon,
                    infoWindow: InfoWindow(
                      title: 'Delivery Boy',
                      snippet:
                          'Lat: ${controller.deliveryBoyLocation.latitude}, Lng: ${controller.deliveryBoyLocation.longitude}',
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: controller.destination,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    infoWindow: InfoWindow(
                      title: 'Destination',
                      snippet:
                          'Lat: ${controller.destination.latitude}, Lng: ${controller.destination.longitude}',
                    ),
                  ),
                },
              ),
              Positioned(
                top: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Order ID: ${controller.myOrder.id ?? 'N/A'}\n'
                      'Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} km',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
