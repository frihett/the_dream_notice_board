import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/data/models/singin_request.dart';
import 'package:the_dream_notice_board/data/models/token_response.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(SignUpRequest request);

  Future<TokenResponse> signIn(SignInRequest request);
}
