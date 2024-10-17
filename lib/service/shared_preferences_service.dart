import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> checkLoginStatus() async {
    await init(); // _prefs-i qururuq
    String? firstName = _prefs!.getString('firstName');
    String? lastName = _prefs!.getString('lastName');

    return firstName != null && lastName != null; // Təmizləmək
  }

  Future<void> clearAllData() async {
    await init(); // _prefs-i qururuq
    await _prefs!.clear(); // Bütün məlumatları silir.
  }

  Future<void> submit(
      String firstNameController, String lastNameController) async {
    await init(); // _prefs-i qururuq
    if (firstNameController.isNotEmpty && lastNameController.isNotEmpty) {
      await _prefs!.setString('firstName', firstNameController);
      await _prefs!.setString('lastName', lastNameController);
    }
  }
}
