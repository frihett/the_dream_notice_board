import 'package:dio/dio.dart';
import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/signup_request.dart';
import 'package:the_dream_notice_board/data/models/singin_request.dart';
import 'package:the_dream_notice_board/data/models/token_response.dart';

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

  @override
  Future<TokenResponse> signIn(SignInRequest request) async {
    try {
      final response = await dio.post(
        'https://front-mission.bigs.or.kr/auth/signin',
        data: request.toJson(),
      );
      return TokenResponse.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? '로그인 실패';

      if (statusCode == 400) {
        throw Exception(message);
      } else {
        throw Exception('로그인 실패');
      }
    } catch (e) {
      throw Exception('예상치 못한 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
