import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Press me"),
        ),
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
