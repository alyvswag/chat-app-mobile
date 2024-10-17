import 'package:chatapp_project/models/groups_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://192.168.1.5:8080/api/v1/group';

  Future<void> addGroupDatabase(GroupsModelDto dto) async {
    try {
      Response response = await _dio.post(
        '$_baseUrl/add-group',
        data: dto.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('Group successfully added!');
      } else {
        print('Failed to add group. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while adding group: $e');
    }
  }

  Future<List<GroupsModel>> getAllGroups() async {
    try {
      Response response = await _dio.get('$_baseUrl/get-all-group');
      if (response.statusCode == 200) {
        // JSON verilənlərini `GroupsModel` listinə çevirmək
        List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => GroupsModel.fromJson(json)).toList();
      } else {
        print('Failed to get groups. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching groups: $e');
      return [];
    }
  }
}
  // Future<List<CharacterModel>> getMultipleCharacters(List<int> id) async {
  //   try {
  //     final response = await _dio.get("/character/${id.join(',')}");
  //     return (response.data as List)
  //         .map((e) => CharacterModel.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


// import 'package:chatapp_project/models/groups_model.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final Dio _dio = Dio();
//   final String _baseUrl =
//       'http://192.168.1.5:8080/api/v1/group/add-group'; // API ünvanı

//   // Model məlumatları
//   final GroupsModelDto groupDto = GroupsModelDto(
//     groupName: 'Flutter2 Group',
//     groupDescription: 'This is a test group created from Flutter',
//     groupPass: '1234',
//   );

//   // POST sorğusu ilə məlumat göndərmək
//   Future<void> _sendGroupData() async {
//     try {
//       Response response = await _dio.post(
//         _baseUrl,
//         data: groupDto.toJson(), // Modeli JSON-a çevirib sorğuya daxil edirik
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json'
//           }, // JSON formatı göndəririk
//         ),
//       );

//       if (response.statusCode == 200) {
//         print('Group successfully added!');
//       } else {
//         print('Failed to add group. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error occurred: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _sendGroupData(); // Sorğunu göndəririk
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Add Group API')),
//         body: Center(
//           child: Text('Check console for API response'),
//         ),
//       ),
//     );
//   }
// }

