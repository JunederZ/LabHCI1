
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labhci1/controllers/register_controller_v2.dart';
import 'package:labhci1/pages/home.dart';
import 'package:labhci1/pages/login.dart';

import '../main.dart';


var routes = <String, WidgetBuilder>{
  '/Login': (context) => const LoginPage(),
  '/Register': (context) => const RegisterController(),
  '/Home': (context) => const HomePage(),
};

class Routes {

  static String? currentRoute = "";
  static String? previousRoute = "";
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Widget? goToPush(String destination) {
    if (!routes.containsKey(destination)){
      throw "cant find the destination!";
    }

    if (currentRoute!.isEmpty){
      currentRoute = routes[destination].toString();
    }
    else {
      previousRoute = currentRoute;
      currentRoute = routes[destination].toString();
    }

    print("now at: " + currentRoute!);
    print("last at: " + previousRoute!);

    NavigatorState? navigator = MyApp.navigatorKey.currentState;
    navigator?.pushReplacement(
        MaterialPageRoute(builder: (_) => routes[destination]!(MyApp.navigatorKey.currentContext!))
    );

    return null;
  }
}

