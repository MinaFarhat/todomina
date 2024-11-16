import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn/Controller/homecontroller.dart';

// ignore: must_be_immutable
class Screen1 extends StatelessWidget {
 Screen1({Key? key}) : super(key: key);
//final e = Get.lazyPut(()=>Homecontroller());
 Homecontroller controller = Get.put(Homecontroller());
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  controller.increment();
                },
                icon: const Icon(Icons.add)),
            GetBuilder<Homecontroller>(
              builder: (controller) => Text(controller.counter.toString()),
            ),
            IconButton(
                onPressed: () {
                  controller.deccrement();
                },
                icon: const Icon(Icons.minimize)),
          ],
        ),
      ),
    );
  }
}
