import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});


  // 요청 보낼 때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await TokenStorage.getAccessToken();


    // 로그인과 회원가입에선 필요 X
    if (options.path.contains('/auth/signin') || options.path.contains('/auth/signup')) {
      return handler.next(options);
    }

    // 토큰 유효성 체크
    if (accessToken != null) {
      // 만료 체크
      final isExpired = JwtDecoder.isExpired(accessToken);

      if (isExpired) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          options.headers['Authorization'] = 'Bearer $newAccessToken';
        } else {
          // 리프레시 실패시 재 로그인
          await TokenStorage.clear();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: '로그인이 필요합니다',
              type: DioExceptionType.unknown,
            ),
          );
        }
      } else {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await dio.post(
        'https://front-mission.bigs.or.kr/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await TokenStorage.saveTokens(newAccessToken, newRefreshToken);
      return newAccessToken;
    } catch (_) {
      await TokenStorage.clear();
      return null;
    }
  }

  // 에러 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await TokenStorage.clear();
    }
    handler.next(err);
  }
}