import 'package:car_track/pages/login_page.dart';
import 'package:car_track/pages/register_page.dart';
import 'package:flutter/material.dart';
//import 'package:fooddeliveryapp/pages/login_page.dart';
//import 'package:fooddeliveryapp/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(onTap: togglePages)
        : RegisterPage(onTap: togglePages);
  }
}
