class GroupsModel {
  final int id;
  final String groupName;
  final String groupDescription;
  final String groupPass; // Dəyişdirildi

  GroupsModel({
    required this.id,
    required this.groupName,
    required this.groupDescription,
    required this.groupPass, // Dəyişdirildi
  });

  GroupsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupName'],
        groupDescription = json['groupDescription'],
        groupPass = json['groupPass']; // Dəyişdirildi
}

class GroupsModelDto {
  final String groupName;
  final String groupDescription;
  final String groupPass;

  GroupsModelDto({
    required this.groupName,
    required this.groupDescription,
    required this.groupPass,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupPass': groupPass,
    };
  }
}
