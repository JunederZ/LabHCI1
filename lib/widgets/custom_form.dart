import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labhci1/controllers/register_controller.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {

  static const _androidIdPlugin = AndroidId();
  var _androidId = 'Unknown';

  final RegisterController controller = RegisterController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initAndroidId();
  }

  Future<void> _initAndroidId() async {
    String androidId;

    try {
      androidId = await _androidIdPlugin.getId() ?? 'Unknown ID';
    } on PlatformException {
      androidId = 'Failed to get Android ID.';
    }

    if (!mounted) return;

    setState(() => _androidId = androidId);
  }

  @override
  Widget build(BuildContext context) {
    controller.deviceIdController.text = _androidId;
    return Form(
      key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility (
                visible: false,
                child: TextFormField(
                  controller: controller.deviceIdController,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Full Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                controller: controller.fullnameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                controller: controller.usernameController,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                controller: controller.passwordController,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(controller.deviceIdController.text);
                    }
                  },
                  child: const Text('Submit'))
            ],
          ),
        ));
  }
}
