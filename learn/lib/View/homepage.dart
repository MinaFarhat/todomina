import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn/View/screen1.dart';
import 'package:learn/main.dart';
class Homepage extends StatelessWidget {
  const Homepage({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:TextButton(
          onPressed:(){
            sharedpref!.setString("id", "1");
            Get.to(()=> Screen1());
          },
          child:const Text("Go to Screen 1"),
        ),
      ),
    );
  }
}