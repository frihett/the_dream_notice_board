import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/singin_request.dart';
import 'package:the_dream_notice_board/data/models/token_response.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_in_usecase.dart';

class SignInViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  bool isLoading = false;
  String? error;
  TokenResponse? token;

  SignInViewModel({required this.signInUseCase});

  Future<void> signIn(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = SignInRequest(username: username, password: password);
      final token = await signInUseCase.execute(request);
      // 토큰 저장
      await TokenStorage.saveTokens(token.accessToken, token.refreshToken);
      //

      // 성공 시 홈 화면으로 이동
      error = null;
    } catch (e) {
      error = '로그인 실패: ${e.toString()}';
    }

    isLoading = false;
    notifyListeners();
  }
}
