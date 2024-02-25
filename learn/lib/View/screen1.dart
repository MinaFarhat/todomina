import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:learn/Controller/homecontroller.dart';

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
                icon: Icon(Icons.add)),
            GetBuilder<Homecontroller>(
              builder: (controller) => Text(controller.counter.toString()),
            ),
            IconButton(
                onPressed: () {
                  controller.deccrement();
                },
                icon: Icon(Icons.minimize)),
          ],
        ),
      ),
    );
  }
}
