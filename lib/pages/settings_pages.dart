import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // ✅ App Bar color updated to match previous screens
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSettingsSection(
            context,
            title: "Appearance",
            children: [
              _buildSettingItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                trailing: CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            title: "Account",
            children: [
              _buildSettingItem(
                context,
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () {
                  // TODO: Implement navigation to Edit Profile page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Edit Profile Tapped")),
                  );
                },
              ),
              _buildSettingItem(
                context,
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {
                  // TODO: Implement navigation to Change Password page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Change Password Tapped")),
                  );
                },
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            title: "About",
            children: [
              _buildSettingItem(
                context,
                icon: Icons.info_outline,
                title: "App Version",
                trailing: const Text("1.0.0", style: TextStyle(color: Colors.grey)),
              ),
              _buildSettingItem(
                context,
                icon: Icons.policy_outlined,
                title: "Privacy Policy",
                onTap: () {
                  // TODO: Implement navigation to Privacy Policy page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Privacy Policy Tapped")),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: children.map((item) {
                final isLast = children.indexOf(item) == children.length - 1;
                return Column(
                  children: [
                    item,
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}