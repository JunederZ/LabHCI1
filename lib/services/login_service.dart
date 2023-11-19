import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:labhci1/utils/encryption.dart';

class AuthService {
  final String password;
  final String udid;
  AuthService(this.password, this.udid);

  login() async {
    var encryptor = EncryptRequest("anggap ini pubkey");
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
    Encrypter encrypter = createFernetEncrypter("nednod", "aufh98qrh28");
    Encrypted encryptedMsg =
        Encrypted.from64(ascii.decode(base64Decode(response.body)));
    String decryptedResponse = encrypter.decrypt(encryptedMsg);
    return decryptedResponse;
  }
}
