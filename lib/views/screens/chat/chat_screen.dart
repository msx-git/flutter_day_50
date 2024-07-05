import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_50/controllers/messages_controller.dart';
import 'package:flutter_day_50/models/user.dart';
import 'package:flutter_day_50/services/push_notification_firebase_service.dart';
import 'package:provider/provider.dart';

import '../../../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.selectedUser,
  });

  final Foydalanuvchi selectedUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedUser.name),
      ),
      body: StreamBuilder(
        stream: context.read<MessagesController>().messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Couldn't fetch messages."),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages found."),
            );
          }

          var messages = snapshot.data!.docs;
          messages.sort((a, b) => a.get('date').compareTo(b.get('date')));
          messages = messages.reversed.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = Message.fromQuery(messages[index]);

                    return (currentUser!.uid == message.senderId &&
                                widget.selectedUser.userId ==
                                    message.receiverId) ||
                            currentUser!.uid == message.receiverId &&
                                widget.selectedUser.userId == message.senderId
                        ? Align(
                            alignment: currentUser!.uid == message.senderId &&
                                    widget.selectedUser.userId ==
                                        message.receiverId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text("${message.text}\n"),
                          )
                        : const Visibility(
                            visible: false, child: Text("No chat history"));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter message here",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        await context
                            .read<MessagesController>()
                            .sendMessage(
                              date: DateTime.now().toString(),
                              receiverId: widget.selectedUser.userId,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              text: textController.text.trim(),
                            )
                            .then(
                          (_) {
                            textController.clear();
                            PushNotificationFirebaseService
                                .sendNotificationMessage(
                              pushToken: widget.selectedUser.pushToken!,
                              title: FirebaseAuth.instance.currentUser!.email!,
                              body: textController.text,
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
