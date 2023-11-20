import 'package:get/get.dart';

import '../constants.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(AdManager());
  }
}
