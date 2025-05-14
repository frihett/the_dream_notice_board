import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/profile/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: viewmodel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이메일: ${viewmodel.username}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('이름: ${viewmodel.name}', style: const TextStyle(fontSize: 18)),
                ],
              ),
      ),
    );
  }
}
