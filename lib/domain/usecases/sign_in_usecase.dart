import 'package:the_dream_notice_board/data/models/singin_request.dart';
import 'package:the_dream_notice_board/data/models/token_response.dart';
import 'package:the_dream_notice_board/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<TokenResponse> execute(SignInRequest request) {
    return repository.signIn(request);
  }
}
