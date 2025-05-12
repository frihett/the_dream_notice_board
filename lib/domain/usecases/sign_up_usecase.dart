import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<void> execute(SignUpRequest request) {
    return repository.signUp(request);
  }
}
