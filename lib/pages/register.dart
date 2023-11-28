import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:labhci1/controllers/register_controller.dart';
import 'package:labhci1/controllers/register_controller_v2.dart';
import 'package:labhci1/services/auth_service.dart';
import 'package:labhci1/widgets/custom_form.dart';
import 'package:platform_device_id/platform_device_id.dart';
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
    // controller = Get.put(RegisterController());
    controller = RegisterController();
    initAsync();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Register"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomForm(
              onSubmit: () => AuthService.register(
                // controller.deviceId.value,
                RegisterController.deviceId,
                // controller.fullname.value,
                RegisterController.fullname,
                // controller.username.value,
                RegisterController.username,
                // controller.password.value,
                RegisterController.password,
                RegisterController.email,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: AuthService.reset,
        child: Icon(Icons.dangerous_outlined),
      ),
    );
  }
}
