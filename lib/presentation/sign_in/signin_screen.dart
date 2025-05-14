import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/sign_in/signin_view_model.dart';
import 'package:the_dream_notice_board/presentation/sign_up/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) =>
                    value!.contains('@') ? null : '이메일 형식이 아닙니다',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value!.length >= 6 ? null : '6자 이상 입력하세요',
              ),
              const SizedBox(height: 16),
              viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.signIn(
                            _usernameController.text,
                            _passwordController.text,
                          );
                          if (viewModel.error == null) {
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
                      child: const Text('로그인'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text('계정이 없으신가요? 회원가입'),
              ),
              if (viewModel.error != null)
                Text(
                  viewModel.error!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
