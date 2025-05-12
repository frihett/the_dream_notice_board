import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_up_usecase.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  bool isLoading = false;
  String? error;

  SignUpViewModel({required this.signUpUseCase});

  Future<void> signUp(String username, String name, String password,
      String confirmPassword) async {
    isLoading = true;
    notifyListeners();

    final request = SignUpRequest(
      username: username,
      name: name,
      password: password,
      confirmPassword: confirmPassword,
    );

    try {
      await signUpUseCase.execute(request);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
