import 'package:flutter/material.dart';
import 'package:labhci1/pages/register.dart';
import 'package:labhci1/services/login_service.dart';
import 'package:platform_device_id/platform_device_id.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  late String? udid;

  void _login(password) {
    AuthService authService = AuthService(password, udid!);
    authService.login();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
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
