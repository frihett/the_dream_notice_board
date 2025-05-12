import 'package:the_dream_notice_board/data/models/signup_request.dart';

abstract class AuthRepository {
  Future<void> signUp(SignUpRequest request);
}
