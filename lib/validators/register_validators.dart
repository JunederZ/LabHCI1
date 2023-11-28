import "package:get/get.dart";
import "package:labhci1/pages/register.dart";
// import 'package:labhci1/controllers/register_controller.dart';
import 'package:labhci1/controllers/register_controller_v2.dart';

class RegisterValidator {

  // final RegisterController controller = Get.put(RegisterController());
  final RegisterController controller = const RegisterController();

  String? usernameValidator(String? value) {
    if (value!.isEmpty) {
      return "Username is Required.";
    }
    if (value!.length < 3){
      return "Username must have at least 3 charaters.";
    }
    controller.updateUsername(value);
    return null;
  }

  String? fullnameValidator(String? value) {
    if (value!.isEmpty) {
      return "Fullname is Required.";
    }
    if (value!.length < 3){
      return "Fullname must have at least 3 charaters.";
    }
    controller.updateFullname(value);
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Email is Required.";
    }
    var regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (!regex){
      return "Your email is invalid.";
    }
    controller.updateEmail(value);
    return null;
  }

  String? passwordValidator(String? value) {

    if (value!.isEmpty) {
      return "Password is Required.";
    }
    var regex = RegExp(r".{6,}$").hasMatch(value!);
    if (!regex){
      return "Password must have at least 6 characters";
    }
    var regex2 = RegExp(r"^.*[a-zA-Z].*$").hasMatch(value!);
    if (!regex2){
      return "Password must contain a letter.";
    }
    var regex3 = RegExp(r"^.*[0-9].*$").hasMatch(value!);
    if (!regex3){
      return "Password must contain a number.";
    }
    controller.updatePassword(value!);
    return null;
  }

  String? phoneValidator(String? value) {

    if (value!.isEmpty) {
      return "Phone number is Required.";
    }
    if (!value!.isNum) {
      return "Phone number only contains numbers.";
    }
    var regex = RegExp(r".{11,}$").hasMatch(value!);
    if (!regex){
      return "Phone number must have at least 11 characters";
    }
    return null;
  }

}