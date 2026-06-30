import 'package:get/get.dart';
import '../controllers/object_hunt_controller.dart';
import '../controllers/object_hunt_exam_controller.dart';

class ObjectHuntBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ObjectHuntController());
  }
}

class ObjectHuntExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ObjectHuntExamController());
  }
}
