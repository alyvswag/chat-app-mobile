import 'package:chatapp_project/app/locator.dart';
import 'package:chatapp_project/models/groups_model.dart';
import 'package:chatapp_project/service/api_service.dart';
import 'package:flutter/material.dart';

class ApiViewModel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  List<GroupsModel>? _groupsModel; // Qrupların siyahısını saxlamaq üçün
  List<GroupsModel>? get groupsModel => _groupsModel; // Getter

  // Bütün qrupları əldə etmək üçün metod
  Future<void> fetchAllGroups() async {
    _groupsModel = await _apiService.getAllGroups(); // API-dən qrupları alır
    notifyListeners(); // UI-nı yeniləmək üçün bildiriş göndərir
  }

  Future<bool> checkGroupPassword(int id, String password) async {
    for (GroupsModel group in _groupsModel!) {
      if (group.id == id && group.groupPass == password) {
        return true;
      }
    }
    return false;
  }
}
