import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';
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
      appBar: AppBar(
        title: const Text('내 정보'),
        centerTitle: true,
        actions: [],
      ),
      body: viewmodel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '프로필',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text('이메일', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                      viewmodel.username ?? '존재 하지 않습니다.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text('이름', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    viewmodel.name ?? '존재 하지 않습니다.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('로그아웃'),
                      onPressed: () async {
                        await TokenStorage.clear();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/signin');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
