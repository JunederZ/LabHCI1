import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/controllers/register_controller.dart';
import 'package:labhci1/pages/login.dart';
import 'package:labhci1/utils/encryption.dart';
import 'package:labhci1/widgets/custom_form.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late RegisterController controller;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
    initSharedPrefs();
  }

  void register() async {
    var url = Uri(
      scheme: 'http',
      host: "192.168.43.254",
      port: 5000,
      path: '/register'
    );
    try {
      final response = await http
          .post(url, headers: {
        "Content-Type": "application/json",
      }, body: jsonEncode({
        'deviceId': controller.deviceId.value,
        'fullname': controller.fullname.value,
        'username': controller.username.value,
        'password':
            hashing(controller.password.value, controller.deviceId.value)
      }));

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(response.body);
        var publicKey = jsonRes['key'];
        prefs.setString('publicKey', publicKey);
        Get.off(const LoginPage());
      } 
    } catch (e) {
      print("terjadi error: $e");
    }
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomForm(onSubmit: () => register()),
          ),
        ],
      ),
    );
  }
}
