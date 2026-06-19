import 'package:get/get.dart';

import '../controllers/raport_controller.dart';

class RaportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RaportController>(
      () => RaportController(),
    );
  }
}
