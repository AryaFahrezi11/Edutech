import 'package:get/get.dart';
import '../../../services/log_service.dart';

class ProfileController extends GetxController {
  
  @override
  void onInit() {
    super.onInit();
    // Load data log saat profil dibuka
    Get.find<LogService>().fetchLogs();
  }
}
