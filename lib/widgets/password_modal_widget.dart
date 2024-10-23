import 'package:chatapp_project/views/api_view_model.dart';
import 'package:chatapp_project/views/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class PasswordModalWidget extends StatefulWidget {
  final String groupName;
  final int id;

  const PasswordModalWidget(
      {Key? key, required this.groupName, required this.id})
      : super(key: key);

  @override
  State<PasswordModalWidget> createState() => _PasswordModalWidgetState();
}

class _PasswordModalWidgetState extends State<PasswordModalWidget> {
  final TextEditingController _passwordController = TextEditingController();
  final _viewModel = ApiViewModel(); // ViewModel yarat

  String? _passwordError;

  void _clearPasswordField() {
    _passwordController.clear();
    setState(() {
      _passwordError = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _viewModel.fetchAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Otağın parolun daxil edin (${widget.groupName} group)'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Parol',
                errorText: _passwordError,
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
          onPressed: () async {
            String password = _passwordController.text.trim();

            setState(() {
              _passwordError =
                  password.isEmpty ? "* Bu sahə boş buraxıla bilməz" : null;
            });

            if (_passwordError == null) {
              print('Daxil olunan parol: $password');

              // Otaq parolunu yoxla
              // await _viewModel.checkGroupPassword(widget.id, password);

              // // Daxil olunmuş parolunu göstərir
              bool passwordIsCorrect =
                  await _viewModel.checkGroupPassword(widget.id, password);
              print(passwordIsCorrect);

              if (!passwordIsCorrect) {
                _passwordError = '* Parol doğru deyil';
                setState(() {});
                return;
              }

              _clearPasswordField(); // Parol sahəsini təmizlə

              Navigator.of(context).pop(); // Dialoqu bağla

              // Məsələn, ChatScreen-ə yönləndir (parolu ötürə bilərsiniz)
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      groupName: widget.groupName,
                    ),
                  ),
                );
              });
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
