import 'dart:convert';

import 'package:chatapp_project/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String groupName; // Qrup adı

  const ChatScreen({Key? key, required this.groupName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];
  late ChatService chatService;
  String? username;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatService = ChatService();
    setUsername();
    // Mesaj gəldikdə işləyəcək funksiyanı təyin edirik
    chatService.onMessageReceived = (String message) {
      setState(() {
        _scrollToBottom();
        messages.add(message);
        _scrollToBottom(); // Yeni mesajı siyahıya əlavə edirik
      });
    };

    // Otağa qoşulma
    chatService.connect(widget.groupName).then((_) {
      print("Connected to chat group: ${widget.groupName}");
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Mesaj əlavə olunduqdan sonra listin ən sonuna sürüşdür
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Controller-i təmizlə
    super.dispose();
  }

  void setUsername() async {
    username = await chatService.getUserName();
  }

  Map<String, dynamic> parseMessageData(String messageData) {
    return jsonDecode(
        messageData); // Mesaj JSON formatında olduğu üçün parsetmək
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    if (username == null) {
      print("Username is null, cannot send message");
      return; // Username null olduqda mesaj göndərilməsin
    }

    final messageData = {
      'message': _messageController.text,
      'user': username,
    };

    // Mesajı göndərin
    chatService.sendMessage(
        widget.groupName, _messageController.text, username!);

    // Mesajı yalnız bir dəfə əlavə edin
    setState(() {});
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.purple[100],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Mesajı pars etmək
                final messageData = messages[index];
                final parsedMessage = parseMessageData(messageData);

                // Mesajın cari istifadəçi tərəfindən göndərilib-göndərilmədiyini yoxla
                bool isCurrentUser = parsedMessage['user'] ==
                    username!; // Cari istifadəçini tanımlamaq

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser ? Colors.purple[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parsedMessage['user'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          parsedMessage['message'],
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
