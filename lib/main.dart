import 'package:chatapp_project/app/locator.dart';
import 'package:chatapp_project/service/shared_preferences_service.dart';
import 'package:chatapp_project/views/api_view_model.dart';

import 'package:chatapp_project/views/app_view.dart';
import 'package:chatapp_project/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Gecikmə simulyasiyası
    await Future.delayed(const Duration(seconds: 2));

    bool loggedIn = await SharedPreferencesService().checkLoginStatus();
    setState(() {
      _isLoggedIn = loggedIn; // Giriş statusunu yeniləyirik
      _isLoading = false; // Yükləmə bitdi
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: _isLoading // Yükləmə vəziyyətinə görə göstəriş
          ? const Center(
              child: CircularProgressIndicator(), // Yükləmə göstəricisi
            )
          : _isLoggedIn // Giriş statusunu yoxlayırıq
              ? const AppView()
              : const LoginScreen(),
    );
  }
}


// import 'package:chatapp_project/models/groups_model.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   GroupsModel? _response;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       Dio dio = Dio();
//       Response response = await dio.get(
//           'http://192.168.1.5:8080/api/v1/group/get-group'); // Spring Boot server ünvanı
//       Response response1 = await dio.get(
//         'http://192.168.1.5:8080/api/v1/group/add-group'
//       );
//       setState(() {
//         _response =
//             GroupsModel.fromJson(response.data); // "Hello World!" geri dönəcək
//       });
//     } catch (e) {
//       setState(() {
//         print(e);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('API Test')),
//         body: Center(
//           child: Text(
//             _response?.groupName ??
//                 'Loading...', // Null yoxlaması ilə təhlükəsiz çağırış
//             style: TextStyle(fontSize: 24),
//           ),
//         ),
//       ),
//     );
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
