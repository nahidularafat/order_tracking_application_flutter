import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../model/my_order.dart';
import 'live_tracking_controller.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  late LiveTrackingController controller;
  late MyOrder order;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> arg = Get.arguments;
    order = arg['order'];

    controller = Get.put(LiveTrackingController());
    controller.myOrder = order;
    controller.updateCurrentLocation(order.latitude ?? 0.0, order.longitude ?? 0.0);
    controller.startTracking(order.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTrackingController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Live Tracking')),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController mapCtrl) {
                  controller.mapController = mapCtrl;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(order.latitude ?? 0.0, order.longitude ?? 0.0),
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: LatLng(order.latitude ?? 0.0, order.longitude ?? 0.0),
                    icon: controller.markerIcon,
                  ),
                  Marker(
                    markerId: const MarkerId('deliveryBoy'),
                    position: controller.deliveryBoyLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} km',
                      style: const TextStyle(fontSize: 16.0),
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
