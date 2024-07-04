import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_50/controllers/messages_controller.dart';
import 'package:flutter_day_50/models/user.dart';
import 'package:provider/provider.dart';

import '../../../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.selectedUser, required this.users});

  final Foydalanuvchi selectedUser;
  final List<QueryDocumentSnapshot> users;

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

          final messages = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = Message.fromQuery(messages[index]);
                    final receiver = widget.users
                        .map((e) => Foydalanuvchi.fromQuery(e))
                        .toList()
                        .firstWhere(
                            (user) => user.userId == message.receiverId);

                    final sender = widget.users
                        .map((e) => Foydalanuvchi.fromQuery(e))
                        .toList()
                        .firstWhere(
                            (user) => user.userId == message.senderId);

                    return FirebaseAuth.instance.currentUser!.uid ==
                                    sender.userId && message.receiverId ==
                        receiver.userId && widget.selectedUser.userId == message.receiverId
                        ? Text("To: ${receiver.email} From ${sender.email}\n${message.text}\n")
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
                            .then((value) => textController.clear());
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
