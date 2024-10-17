import 'package:chatapp_project/views/screens/chat_screen.dart';
import 'package:chatapp_project/widgets/modal_widget_viewmodel.dart';
import 'package:flutter/material.dart';

class ModalWidget extends StatefulWidget {
  final BuildContext context;
  const ModalWidget({super.key, required this.context});

  @override
  State<ModalWidget> createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<ModalWidget> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController =
      TextEditingController();
  final TextEditingController _roomPasswordController = TextEditingController();

  String? _roomNameError; // Otaq adı xətası
  String? _roomDescriptionError; // Otaq təsviri xətası
  String? _roomPasswordError; // Otaq parolu xətası

  void _clearRoomFields() {
    _roomNameController.clear();
    _roomDescriptionController.clear();
    _roomPasswordController.clear();
    setState(() {
      _roomNameError = null; // Xətaları sıfırla
      _roomDescriptionError = null;
      _roomPasswordError = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Otaq Yarat'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                labelText: 'Otaq adı',
                errorText: _roomNameError, // Xətanı göstərin
              ),
            ),
            TextField(
              controller: _roomDescriptionController,
              decoration: InputDecoration(
                labelText: 'Otaq təsviri',
                errorText: _roomDescriptionError, // Xətanı göstərin
              ),
            ),
            TextField(
              controller: _roomPasswordController,
              decoration: InputDecoration(
                labelText: 'Otaq parolu',
                errorText: _roomPasswordError, // Xətanı göstərin
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Otaq adını, təsvirini və parolunu alırıq
            String roomName = _roomNameController.text.trim();
            String roomDescription = _roomDescriptionController.text.trim();
            String roomPassword = _roomPasswordController.text.trim();

            // Sahələri yoxlayın
            setState(() {
              _roomNameError =
                  roomName.isEmpty ? "* Bu sahə boş buraxıla bilməz" : null;
              _roomDescriptionError = roomDescription.isEmpty
                  ? "* Bu sahə boş buraxıla bilməz"
                  : null;
              _roomPasswordError =
                  roomPassword.isEmpty ? "* Bu sahə boş buraxıla bilməz" : null;
            });

            // Əgər bütün sahələr doludursa
            if (_roomNameError == null &&
                _roomDescriptionError == null &&
                _roomPasswordError == null) {
              // Məlumatları istifadə edərək istədiyiniz əməliyyatları yerinə yetirin
              print('Otaq adı: $roomName');
              print('Otaq təsviri: $roomDescription');
              print('Otaq parolu: $roomPassword');

              // Otaq adını ChatScreen ekranına göndəririk
              _clearRoomFields(); // Forma sahələrini təmizləyirik
              Navigator.of(context).pop(); // Dialoqu bağlayırıq

              // Dialoq bağlandıqdan sonra ChatScreen-ə yönləndir
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(widget.context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        groupName: roomName), // Qrup adını burada ötür
                  ),
                );
              });

              ModalWidgetViewmodel()
                  .addGroup(roomName, roomDescription, roomPassword);
            }
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialoqu bağla
          },
          child: const Text('İmtina et'),
        ),
      ],
    );
  }
}
