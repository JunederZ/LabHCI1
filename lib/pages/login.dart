import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:labhci1/pages/home.dart';
import 'package:labhci1/pages/register.dart';
import 'package:labhci1/services/auth_service.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  late String? udid;
  late SharedPreferences prefs;

  void _login(password) async {
    String res = await AuthService.login(udid, password!);
    Map resJson = jsonDecode(res);
    if (resJson['msg'] == "password salah") {
      Fluttertoast.showToast(
        msg: "Incorrect password",
        // backgroundColor: Color.fromARGB(255, 53, 4, 0),
        // textColor: Color.fromARGB(255, 238, 185, 183),
        backgroundColor: Color.fromARGB(255, 215, 160, 155),
        textColor: Color.fromARGB(255, 59, 4, 2),
        timeInSecForIosWeb: 3,
      );
    } else if (resJson['msg'] == 'success') {
      Get.off(const HomePage());
    }
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

  void getUDID() async {
    udid = await PlatformDeviceId.getDeviceId;
  }

  @override
  void initState() {
    getUDID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: UnderlineInputBorder(),
                labelText: 'Password',
              ),
              controller: passwordController,
            ),
            // const SizedBox(height: 10),
            // FutureBuilder(
            //   future: PlatformDeviceId.getDeviceId,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text('UDID: ${snapshot.data!}');
            //     } else {
            //       return const Text('UDID WHAT');
            //     }
            //   },
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: Theme.of(context).colorScheme.errorContainer,
              //   foregroundColor: Theme.of(context).colorScheme.error,
              // ),
              onPressed: () => _login(passwordController.text),
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const RegisterPage();
                }));
              },
              child: const Text('Register'),
            ),
          ]),
        ),
      ),
    );
  }
}
