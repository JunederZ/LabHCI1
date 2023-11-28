import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:labhci1/validators/register_validators.dart";
import "package:labhci1/pages/register.dart";


class RegisterController extends StatefulWidget {

  static late String? deviceId;
  static late String? fullname;
  static late String? username;
  static late String? password;
  static late String? email;

  const RegisterController({super.key});

  void resetData() {
    deviceId = null;
    fullname = null;
    username = null;
    password = null;
    email = null;
  }

  void updateDeviceId(String value) => deviceId = value;
  void updateFullname(String value) => fullname = value;
  void updateUsername(String value) => username = value;
  void updatePassword(String value) => password = value;
  void updateEmail(String value) => email = value;

  @override
  _RegisterControllerState createState() => _RegisterControllerState();

}

class _RegisterControllerState extends State<RegisterController> {

  late String? _deviceId;
  late String? _fullname;
  late String? _username;
  late String? _password;
  late String? _email;


  @override
  void initState() {
    super.initState();
    _deviceId = RegisterController.deviceId;
    _fullname = RegisterController.fullname;
    _username = RegisterController.username;
    _password = RegisterController.password;
    _email = RegisterController.email;
  }

  @override
  Widget build(BuildContext context) {
    return const RegisterPage();
  }

}