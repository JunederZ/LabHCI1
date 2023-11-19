import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart' as crypto;
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';
import 'package:http/http.dart' as http;

class EncryptRequest {
  final String publicKey;
  late crypto.RSAPublicKey publicKeyPem;

  EncryptRequest(this.publicKey) {
    _parsePublicKeyFromPem(publicKey);
  }

  Future<dynamic> encryptPost(Uri url, Map<String, String>? headers,
      Map<String, dynamic>? body, Encoding? encoding) async {
    var response = await http.post(url, headers: headers, body: {
      'message': base64Encode(_encryptRSA(jsonEncode(body), publicKeyPem)),
    });

    return response;
  }

  void _parsePublicKeyFromPem(String pemString) {
    final parser = RSAKeyParser();
    publicKeyPem = parser.parse(pemString) as crypto.RSAPublicKey;
  }

  List<int> _encryptRSA(String plainText, crypto.RSAPublicKey rsaKey) {
    final encryptor = PKCS1Encoding(RSAEngine())
      ..init(true, PublicKeyParameter<crypto.RSAPublicKey>(rsaKey));

    final encryptedText =
        encryptor.process(Uint8List.fromList(utf8.encode(plainText)));

    return encryptedText;
  }
}

String hashing(String input, String salt) {
  final combined = utf8.encode('$input$salt');
  final hashedBytes = sha256.convert(combined);
  final hashedPassword = hashedBytes.toString();

  return hashedPassword;
}
