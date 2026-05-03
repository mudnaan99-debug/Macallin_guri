import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherId;
  const ChatScreen({required this.chatId, required this.otherId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final uid = context.watch<SessionController>().currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherId}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: firestoreService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = uid != null && msg.senderId == uid;

                    return BubbleSpecialThree(
                      text: msg.message,
                      color: isMe ? Colors.amber : const Color(0xFFE8E8EE),
                      tail: true,
                      textStyle: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      isSender: isMe,
                    );
                  },
                );
              },
            ),
          ),
          MessageBar(
            onSend: (text) {
              if (text.trim().isNotEmpty && uid != null) {
                 MessageModel msg = MessageModel(
                   id: '',
                   senderId: uid,
                   message: text.trim(),
                   createdAt: DateTime.now(),
                 );
                 firestoreService.sendMessage(widget.chatId, msg);
              }
            },
          ),
        ],
      ),
    );
  }
}
