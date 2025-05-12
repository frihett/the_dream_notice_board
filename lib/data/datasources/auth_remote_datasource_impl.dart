import 'package:dio/dio.dart';
import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/signup_request.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});


  @override
  Future<void> signUp(SignUpRequest request) async {
    try {
      await dio.post(
        'https://front-mission.bigs.or.kr/auth/signup',
        data: request.toJson(),
      );
      print("회원가입 성공");
    } catch (e) {
      throw Exception("회원가입 실패: ${e.toString()}");
    }
  }
}