import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/chat_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final uid = context.watch<SessionController>().currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('My Chats')),
      body: StreamBuilder<List<ChatModel>>(
        stream: uid == null
            ? Stream.value(<ChatModel>[])
            : firestoreService.getMyChats(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No active conversations.'));
          }

          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherId = chat.participants.firstWhere((p) => p != user.uid);
              
              return ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person)),
                title: Text('Chat with $otherId'), // Use a lookup for name if possible
                subtitle: Text(chat.lastMessage, maxLines: 1),
                trailing: Text('${chat.updatedAt.hour}:${chat.updatedAt.minute}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chat.id, otherId: otherId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
