import 'dart:convert';
import 'package:encrypt/encrypt.dart';
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
        print(udid);
        var jsonRes = jsonDecode(decryptedResponse);
        print(jsonRes);
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
}
