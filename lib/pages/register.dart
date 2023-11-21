import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/controllers/register_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late String? udid;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
    getUDID();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getUDID() async {
    udid = await PlatformDeviceId.getDeviceId;
  }

  void _unregist() async {
    String res = await AuthService.unregist(udid);
    if (res == "success") {
      Fluttertoast.showToast(
        msg: "Success unregister device",
        // backgroundColor: Color.fromARGB(255, 53, 4, 0),
        // textColor: Color.fromARGB(255, 238, 185, 183),
        backgroundColor: const Color.fromARGB(255, 215, 160, 155),
        textColor: const Color.fromARGB(255, 59, 4, 2),
        timeInSecForIosWeb: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Register"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _unregist();
        },
        backgroundColor: Theme.of(context).colorScheme.onError,
        foregroundColor: Theme.of(context).colorScheme.error,
        icon: const Icon(Icons.phonelink_erase),
        label: const Text("Unregist Device"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomForm(
              onSubmit: () => AuthService.register(
                controller.deviceId.value,
                controller.fullname.value,
                controller.username.value,
                controller.password.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
