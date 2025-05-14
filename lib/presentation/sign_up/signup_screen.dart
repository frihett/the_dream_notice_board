import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/sign_up/signup_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidPassword(String password) {
    // 8자 이상, 숫자, 영문자, 특수문자(!%*#?&) 1개 이상의 조합
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!%*#?&])[A-Za-z\d!%*#?&]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 이메일
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return '올바른 이메일을 입력하세요';
                  }
                  return null;
                },
              ),

              // 이름
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) =>
                    value == null || value.isEmpty ? '이름을 입력하세요' : null,
              ),

              // 비밀번호
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || !_isValidPassword(value)) {
                    return '8자 이상, 영문/숫자/특수문자 포함';
                  }
                  return null;
                },
              ),

              // 비밀번호 확인
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 가입 버튼
              viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final isSuccess = await viewModel.signUp(
                            _usernameController.text,
                            _nameController.text,
                            _passwordController.text,
                            _confirmPasswordController.text,
                          );
                          if (isSuccess && mounted) {
                            Navigator.pushReplacementNamed(context, '/signin');
                          }
                        }
                      },
                      child: const Text('가입하기'),
                    ),

              const SizedBox(height: 10),

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
