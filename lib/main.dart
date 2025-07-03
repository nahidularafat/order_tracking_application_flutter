//import 'package:car_track/pages/my_home_page.dart';
import 'package:car_track/services/auth/auth_gate.dart';
import 'package:car_track/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
//import 'my_home_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // Provider for state management
//import '../p/themes/theme_provider.dart'; // ThemeProvider import
//import '../model/my_order.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BUBT BUS TRACK',
      home: const AuthGate(),
      theme: themeProvider.themeData,
    );
  }
}
