import 'package:get/get.dart';

class LetterSelectionController extends GetxController {
  // Generate list huruf A-Z secara otomatis
  final List<String> letters = List.generate(26, (index) => String.fromCharCode(65 + index));
}
