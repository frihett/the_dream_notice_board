import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> signUp(SignUpRequest request) {
    return remoteDataSource.signUp(request);
  }
}
