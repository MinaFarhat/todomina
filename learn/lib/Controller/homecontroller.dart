import 'package:get/get.dart';

class Homecontroller extends GetxController{
 var counter=0;
 void increment(){
  counter++;
  update();
 }
  void deccrement(){
  counter--;
  update();
 }
}