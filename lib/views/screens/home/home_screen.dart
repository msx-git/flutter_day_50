import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_50/controllers/auth_controller.dart';
import 'package:flutter_day_50/controllers/users_controller.dart';
import 'package:flutter_day_50/models/user.dart';
import 'package:flutter_day_50/views/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat App',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthController>().signOut(),
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: context.read<UsersController>().users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Couldn't fetch users."),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No users found."),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.separated(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = Foydalanuvchi.fromQuery(users[index]);
              print(
                  "user id: ${user.userId}");
              print(
                  "Current user id: ${FirebaseAuth.instance.currentUser!.uid}");
              return FirebaseAuth.instance.currentUser!.email == user.email
                  ? ListTile(
                      leading: Text("${index + 1}"),
                      title: const Text("Saved messages"),
                      subtitle: Text("${user.name}: ${user.email}"),
                      onTap: () {},
                    )
                  : ListTile(
                      leading: Text("${index + 1}"),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChatScreen(
                            selectedUser: user,
                            users: users,
                          ),
                        ),
                      ),
                    );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}
