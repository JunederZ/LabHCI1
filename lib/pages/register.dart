import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/controllers/register_controller.dart';
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
    final response =
        await http.post(Uri.parse("http://127.0.0.1:5000"), headers: {
      "Content-Type": "application/json",
    }, body: {
      'fullname': controller.fullname.value,
      'username': controller.username.value,
      'password': controller.password.value
    });

    print(response);
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
            child: CustomForm(onSubmit: () {
              return register();
            }),
          ),
        ],
      ),
    );
  }
}
