import 'dart:convert';
import 'dart:ui';
import 'package:encrypt/encrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:labhci1/pages/login.dart';
import 'package:labhci1/utils/encryption.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future register(deviceId, fullName, username, password) async {
    String? udid = await PlatformDeviceId.getDeviceId;
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
          'fullname': fullName,
          'username': username,
          'password': password,
        }),
      );

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
            // backgroundColor: Color.fromARGB(255, 53, 4, 0),
            // textColor: Color.fromARGB(255, 238, 185, 183),
            backgroundColor: const Color.fromARGB(255, 215, 160, 155),
            textColor: const Color.fromARGB(255, 59, 4, 2),
            timeInSecForIosWeb: 3,
          );
          return;
        }
        var publicKey = jsonRes['key'];
        prefs.setString('publicKey', publicKey);
        Get.off(const LoginPage());
      }
    } catch (e) {
      print("terjadi error: $e");
    }
  }

  static Future<String> login(udid, password) async {
    // get public key to working
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? publicKey = prefs.getString("publicKey");
    var encryptor = EncryptRequest(publicKey!);
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

  static Future<String> unregist(udid) async {
    // get public key to working
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri(
      scheme: 'http',
      host: "103.134.154.22",
      port: 5000,
      path: '/unregist',
    );
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {
      "udid": udid,
    };
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return response.body;
  }
}
