import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:labhci1/controllers/register_controller.dart';

class CustomForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const CustomForm({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {

  static const _androidIdPlugin = AndroidId();
  var _androidId = 'Unknown';

  final RegisterController controller = Get.put(RegisterController());

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
    controller.updateDeviceId(_androidId);
    return Form(
      key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility (
                visible: false,
                child: TextFormField(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Full Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  controller.updateFullname(value);
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  controller.updateUsername(value);
                  return null;
                },
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
                  controller.updatePassword(value);
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit?.call();
                    }
                  },
                  child: const Text('Submit'))
            ],
          ),
        ));
  }
}
