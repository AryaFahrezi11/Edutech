import 'package:get/get.dart';
import '../controllers/object_hunt_selection_controller.dart';

class ObjectHuntSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObjectHuntSelectionController>(
      () => ObjectHuntSelectionController(),
    );
  }
}
