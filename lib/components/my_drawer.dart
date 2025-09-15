import 'package:car_track/pages/settings_pages.dart';
import 'package:car_track/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../pages/my_home_page.dart';
import '../pages/login_page.dart';
// Import the new pages (you will need to create these files)
// import '../pages/my_profile_page.dart'; 
// import '../pages/student_requests_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final authService = AuthService();
    authService.signOut();
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';
    final bool isDriver = email.toLowerCase() == 'driver@bubt.com';
    final String userRole = isDriver ? 'Driver' : 'Student';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Premium Drawer Header with App Name and Icon
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'BUBT BUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  userRole,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  title: "H O M E",
                  icon: Icons.home_outlined,
                  onTap: () {
                    Get.offAll(() => MyHomePage(email: email));
                  },
                ),
                // New feature for students: My Profile
                if (!isDriver)
                  _buildDrawerItem(
                    context,
                    title: "M Y P R O F I L E",
                    icon: Icons.person_outline,
                    onTap: () {
                      Get.back();
                      // Get.to(() => const MyProfilePage()); // TODO: Implement MyProfilePage
                    },
                  ),
                // New feature for drivers: View Student Requests
                if (isDriver)
                  _buildDrawerItem(
                    context,
                    title: "S T U D E N T S",
                    icon: Icons.group_outlined,
                    onTap: () {
                      Get.back();
                      // Get.to(() => const StudentRequestsPage()); // TODO: Implement StudentRequestsPage
                    },
                  ),
                _buildDrawerItem(
                  context,
                  title: "S E T T I N G S",
                  icon: Icons.settings_outlined,
                  onTap: () {
                    Get.back();
                    Get.to(() => const SettingsPage());
                  },
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1, color: Colors.grey),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: _buildDrawerItem(
              context,
              title: "L O G O U T",
              icon: Icons.logout_outlined,
              onTap: () {
                logout(context);
              },
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      onTap: onTap,
      splashColor: Colors.blue.withOpacity(0.2),
    );
  }
}