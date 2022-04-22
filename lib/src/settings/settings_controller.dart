import 'package:flutter/foundation.dart';
import 'package:lab1_provider_messager/src/settings/settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController() {
    service = SettingsService(this);
  }

  late SettingsService service;

  bool _isFirstInit = false;
  bool get getIsFirstInit => _isFirstInit;
  setIsFirstInit(bool first) {
    _isFirstInit = first;
    notifyListeners();
  }
}
