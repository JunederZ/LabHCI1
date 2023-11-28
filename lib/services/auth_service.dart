import 'dart:convert';
import 'dart:ui';
import 'package:encrypt/encrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:labhci1/pages/login.dart';
import 'package:labhci1/utils/encryption.dart';
import 'package:labhci1/routes/routes.dart';
import 'package:labhci1/controllers/register_controller_v2.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future reset() async {
    print('test');
    String? udid = await PlatformDeviceId.getDeviceId;
    var url = Uri(
      scheme: 'http',
      host: "103.134.154.22",
      port: 5000,
      path: '/reset',
    );
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "text/plain",
      },
      body: udid,
    );
    print(response.body);
    Fluttertoast.showToast(
      msg: "Account reset success",
      backgroundColor: Color.fromARGB(255, 175, 215, 155),
      textColor: Color.fromARGB(255, 2, 59, 17),
      timeInSecForIosWeb: 3,
    );
  }

  static Future register(deviceId, fullName, username, password, email) async {
    String? udid = await PlatformDeviceId.getDeviceId;
    print("${deviceId!} ${fullName} ${username} ${password} ${email} start");
    var url = Uri(
      scheme: 'http',
      host: "103.134.154.22",
      port: 5000,
      path: '/register',
    );
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'deviceId': udid,
          'fullName': fullName,
          'username': username,
          'password': password,
          'email': email,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(response.body);

        Encrypter encrypter = createFernetEncrypter(udid!, "");
        Encrypted encryptedMsg =
            Encrypted.from64(ascii.decode(base64Decode(response.body)));
        String decryptedResponse = encrypter.decrypt(encryptedMsg);
        // return decryptedResponse;
        var jsonRes = jsonDecode(decryptedResponse);
        if (jsonRes['status'] == 'device already exists') {
          Fluttertoast.showToast(
            msg: "Device already registered",
            backgroundColor: const Color.fromARGB(255, 215, 160, 155),
            textColor: const Color.fromARGB(255, 59, 4, 2),
            timeInSecForIosWeb: 3,
          );
          return;
        }
        var publicKey = jsonRes['key'];
        prefs.setString('publicKey', publicKey);
        // Get.off(const LoginPage());
        Routes().goToPush('/Login');

      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: const Color.fromARGB(255, 215, 160, 155),
        textColor: const Color.fromARGB(255, 59, 4, 2),
        timeInSecForIosWeb: 3,
      );
    }
  }

  static Future<String> login(udid, password) async {
    // get public key to working
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? publicKey = prefs.getString("publicKey");
    if (publicKey == null) {
      return "not registered";
    }
    var encryptor = EncryptRequest(publicKey);
    var url = Uri(
      scheme: 'http',
      host: "103.134.154.22",
      port: 5000,
      path: '/login',
    );
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {
      "udid": udid,
      "password": password,
    };
    String encryptedBody = encryptor.encrypt(jsonEncode(body));
    var response = await http.post(
      url,
      headers: headers,
      body: encryptedBody,
    );
    Encrypter encrypter = createFernetEncrypter(udid, "");
    Encrypted encryptedMsg =
        Encrypted.from64(ascii.decode(base64Decode(response.body)));
    String decryptedResponse = encrypter.decrypt(encryptedMsg);
    return decryptedResponse;
  }
}
