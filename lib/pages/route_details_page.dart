import 'package:flutter/material.dart';

class RouteDetailsPage extends StatelessWidget {
  const RouteDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/i-made-some-line-route-maps-for-each-of-the-planned-dhaka-v0-8a0tzjfoycbc1.png',
          width: 720,
          height: 1080,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
