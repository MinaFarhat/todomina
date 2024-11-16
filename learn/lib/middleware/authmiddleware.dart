import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn/main.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharedpref!.getString("id") != null) {
      return const RouteSettings(name: "/m");
    }
    return null;
  }
}
