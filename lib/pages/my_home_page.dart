import 'package:car_track/add_order/add_order.dart';
import 'package:car_track/components/my_drawer.dart';
import 'package:car_track/delivery_boy_app/delivery_boy_page.dart';
import 'package:car_track/order_list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'route_details_page.dart'; // ✅ Make sure this import path is correct

class MyHomePage extends StatelessWidget {
  final String email;

  const MyHomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final bool isDriver = email.toLowerCase() == 'driver@bubt.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Track', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isDriver)
              _buildCard(
                context,
                title: 'BUS FROM MY LOCATION',
                icon: Icons.my_location, // ✅ Icon changed here
                color: Colors.red,
                onTap: () {
                  Get.to(const AddOrderPage());
                },
              ),
            if (isDriver) ...[
              _buildCard(
                context,
                title: 'Driver App',
                icon: Icons.local_shipping,
                color: Colors.red,
                onTap: () {
                  Get.to(const DeliveryBoyPage());
                },
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                title: 'View Bus List',
                icon: Icons.directions_bus,
                color: Colors.green,
                onTap: () {
                  Get.to(const OrdersListPage());
                },
              ),
            ],
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: 'Route Details',
              icon: Icons.route,
              color: Colors.blue,
              onTap: () {
                Get.to(const RouteDetailsPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  // A reusable widget to create a beautiful, tappable card
  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(//
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}