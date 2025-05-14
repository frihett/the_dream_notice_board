import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/data/models/singin_request.dart';
import 'package:the_dream_notice_board/data/models/token_response.dart';
import 'package:the_dream_notice_board/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> signUp(SignUpRequest request) {
    return remoteDataSource.signUp(request);
  }

  @override
  Future<TokenResponse> signIn(SignInRequest request) {
    return remoteDataSource.signIn(request);
  }
}
