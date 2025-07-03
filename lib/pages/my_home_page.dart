import 'package:car_track/add_order/add_order.dart';
import 'package:car_track/components/my_drawer.dart';
import 'package:car_track/delivery_boy_app/delivery_boy_page.dart';
import 'package:car_track/order_list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'route_details_page.dart'; // ✅ নতুন পেজ import করো

class MyHomePage extends StatelessWidget {
  final String email;

  const MyHomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final bool isDriver = email.toLowerCase() == 'driver@bubt.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose App'),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isDriver)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.to(const AddOrderPage());
                },
                child: const Text('Student App'),
              ),
            if (isDriver) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.to(const DeliveryBoyPage());
                },
                child: const Text('Driver App'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.to(const OrdersListPage());
                },
                child: const Text('View Orders List'),
              ),
            ],
            const SizedBox(height: 20),

            // ✅ Route Details Button (common for all)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.to(const RouteDetailsPage());
              },
              child: const Text('Route Details'),
            ),
          ],
        ),
      ),
    );
  }
}
