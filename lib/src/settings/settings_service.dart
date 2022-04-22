import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService(this.controller) {
    init();
  }
  SettingsController controller;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    getPrefFirstInit();
  }

  late SharedPreferences prefs;

  getPrefFirstInit() async {
    controller.setIsFirstInit(true);
    print('is first time');

    // var first = prefs.getBool('first_init');
    // if (first == null) {
    //   prefs.setBool('first_init', false);
    //   controller.setIsFirstInit(true);
    // } else {
    //   print('is not first time');
    //   controller.setIsFirstInit(false);
    // }
  }
}
