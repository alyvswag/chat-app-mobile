import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupName; // Qrup adını burada saxlayırıq

  const ChatScreen({Key? key, required this.groupName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName), // Qrup adını buradan alırıq
        backgroundColor: Colors.purple[100],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                // Boş olan ekranın ortasında sadəcə mesajlar yerləşəcək
              ],
            ),
          ),
          _buildMessageInput(), // Mesaj yazma sahəsi
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
            onTap: () {
              // Mesaj göndərmə prosesi
              print("Message sent: ${_messageController.text}");
              _messageController
                  .clear(); // Mesaj göndərildikdən sonra təmizlənir
            },
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
