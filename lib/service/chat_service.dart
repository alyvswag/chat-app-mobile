import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  late StompClient stompClient;

  Function(String message)? onMessageReceived;

  Future<void> connect(String groupName) async {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.1.5:3000/chat-socket', // Backend WebSocket URL
        onConnect: (StompFrame frame) {
          print("Connected to WebSocket");

          stompClient.subscribe(
            destination: '/topic/$groupName', // Otaq adı ilə WebSocket mövzusu
            callback: (StompFrame frame) {
              if (frame.body != null) {
                // Mesajın null olub olmadığını yoxlayın
                if (onMessageReceived != null) {
                  onMessageReceived!(frame
                      .body!); // Yeni mesaj gəldikdə UI-ya mesaj göndərilir
                } else {
                  print("onMessageReceived is null");
                }
              } else {
                print("Received message is null");
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => print("WebSocket error: $error"),
      ),
    );

    stompClient.activate();
  }

  void sendMessage(String groupName, String message, String user) {
    final messageData = {
      'message': message,
      'user': user,
    };
    stompClient.send(
      destination: '/app/chat/$groupName',
      body: jsonEncode(messageData), // JSON formatında göndərin
    );
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String firstName = prefs.getString('firstName') ?? 'Unknown';
    String lastName = prefs.getString('lastName') ?? '';
    return '$firstName $lastName';
  }
}
