import 'package:car_track/pages/settings_pages.dart';
import 'package:car_track/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/my_home_page.dart';
import '../pages/login_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final authService = AuthService();
    authService.signOut(); // Firebase থেকে sign out

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.bus_alert,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),

          // Home Tile
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            title: const Text("H O M E"),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(email: email), // ✅ email পাঠানো হয়েছে
                ),
              );
            },
          ),

          // Settings Tile
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            title: const Text("S E T T I N G S"),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          const Spacer(),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),

          // Logout Tile
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            title: const Text("L O G O U T"),
            onTap: () {
              logout(context);
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
