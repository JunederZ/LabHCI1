import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:labhci1/pages/home.dart';

import 'package:labhci1/controllers/register_controller_v2.dart';
import 'package:labhci1/services/auth_service.dart';
import 'package:labhci1/routes/routes.dart';
import 'package:platform_device_id/platform_device_id.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();

  void _login(password) async {
    String? udid = await PlatformDeviceId.getDeviceId;
    String res = await AuthService.login(udid, password!);
    if (res == 'not registered') {
      Fluttertoast.showToast(
        msg: "Device isn't registered",
        backgroundColor: const Color.fromARGB(255, 215, 160, 155),
        textColor: const Color.fromARGB(255, 59, 4, 2),
        timeInSecForIosWeb: 3,
      );
      return;
    }
    Map resJson = jsonDecode(res);
    if (resJson['msg'] == "password salah") {
      Fluttertoast.showToast(
        msg: "Incorrect password",
        backgroundColor: const Color.fromARGB(255, 215, 160, 155),
        textColor: const Color.fromARGB(255, 59, 4, 2),
        timeInSecForIosWeb: 3,
      );
    } else if (resJson['msg'] == 'success') {
      Routes().goToPush("/Home");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
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
              onPressed: () => Routes().goToPush("/Register"),
              child: const Text('Register'),
            ),
          ]),
        ),
      ),
    );
  }
}
