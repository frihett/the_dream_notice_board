import 'package:the_dream_notice_board/data/models/signup_request.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(SignUpRequest request);
}