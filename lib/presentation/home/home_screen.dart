import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 화면'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await TokenStorage.clear();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('환영합니다! 홈 화면입니다.'),
      ),
    );
  }
}