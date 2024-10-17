import 'package:chatapp_project/app/locator.dart';
import 'package:chatapp_project/models/groups_model.dart';
import 'package:chatapp_project/service/api_service.dart';

class ModalWidgetViewmodel {
  final _apiService = locator<ApiService>();

  GroupsModel? _groupsModel;
  GroupsModel? get groupsModel => _groupsModel;

  Future<void> addGroup(String groupN, String groupD, String groupP) async {
    await _apiService.addGroupDatabase(GroupsModelDto(
      groupName: groupN,
      groupDescription: groupD,
      groupPass: groupP,
    ));
  }
}
