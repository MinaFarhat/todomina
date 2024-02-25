import 'package:get/get.dart';
import 'package:learn/Controller/homecontroller.dart';

class Box implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=>Homecontroller(),fenix: true);
  }

}