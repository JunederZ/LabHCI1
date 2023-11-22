import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/pages/login.dart';
import 'package:labhci1/utils/encryption.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  String requestText = 'null';
  String plainRequestText = 'null';
  String responseText = 'null';
  String plainResponseText = 'null';

  void send() async {
    String? udid = await PlatformDeviceId.getDeviceId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? publicKey = prefs.getString("publicKey");
    var encryptor = EncryptRequest(publicKey!);
    var url = Uri(
      scheme: 'http',
      host: "103.134.154.22",
      port: 5000,
      path: '/ping',
    );
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {
      "value": textController.text,
      "deviceId": udid!,
    };
    String encryptedBody = encryptor.encrypt(jsonEncode(body));
    setState(() {
      requestText = encryptedBody;
      plainRequestText = jsonEncode(body);
    });
    var response = await http.post(
      url,
      headers: headers,
      body: encryptedBody,
    );
    Encrypter encrypter = createFernetEncrypter(udid, "");
    Encrypted encryptedMsg =
        Encrypted.from64(ascii.decode(base64Decode(response.body)));
    String decryptedResponse = encrypter.decrypt(encryptedMsg);
    setState(() {
      responseText = encryptedMsg.base64;
      plainResponseText = decryptedResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("encrypted request data:"),
          const SizedBox(height: 5),
          Text(requestText),
          const SizedBox(height: 20),
          const Text("plain request data:"),
          const SizedBox(height: 5),
          Text(plainRequestText),
          const SizedBox(height: 20),
          const Text("encrypted response data:"),
          const SizedBox(height: 5),
          Text(responseText),
          const SizedBox(height: 20),
          const Text("plain response data:"),
          const SizedBox(height: 5),
          Text(plainResponseText),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              // border: OutlineInputBorder(),
              border: UnderlineInputBorder(),
              labelText: 'Value',
            ),
            controller: textController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: send,
            child: const Text("Press me!"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(const LoginPage());
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
