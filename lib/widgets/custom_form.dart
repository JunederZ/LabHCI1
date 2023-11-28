import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:labhci1/controllers/register_controller.dart';
import 'package:labhci1/controllers/register_controller_v2.dart';
import 'package:labhci1/routes/routes.dart';
import 'package:labhci1/validators/register_validators.dart';
import 'package:labhci1/pages/login.dart';

class CustomForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const CustomForm({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  static const _androidIdPlugin = AndroidId();
  var _androidId = 'Unknown';

  // final RegisterController controller = Get.put(RegisterController());
  final RegisterController controller = const RegisterController();
  final RegisterValidator validator = RegisterValidator();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initAndroidId();
    controller.resetData();
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    controller.resetData();
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

    controller.updateDeviceId(_androidId);
  }

  @override
  Widget build(BuildContext context) {

    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: false,
                child: TextFormField(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Full Name'),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator.fullnameValidator,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator.usernameValidator,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator.passwordValidator,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator.emailValidator,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit?.call();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () => Routes().goToPush("/Login"),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
