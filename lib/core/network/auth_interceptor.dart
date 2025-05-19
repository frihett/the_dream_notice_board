import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  Completer<String?>? _refreshCompleter;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await TokenStorage.getAccessToken();
    print("[${options.method}] ${options.uri} - accessToken: $accessToken");

    // 로그인/회원가입 요청은 토큰 불필요
    if (options.path.contains('/auth/signin') || options.path.contains('/auth/signup')) {
      return handler.next(options);
    }

    if (accessToken != null) {
      final isExpired = JwtDecoder.isExpired(accessToken);

      if (isExpired) {
        final newAccessToken = await _refreshToken();

        if (newAccessToken != null) {
          options.headers['Authorization'] = 'Bearer $newAccessToken';
        } else {
          await TokenStorage.clear();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: '로그인이 필요합니다.',
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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 발생 시 토큰 갱신 후 요청 재시도
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/refresh')) {
      final newAccessToken = await _refreshToken();

      if (newAccessToken != null) {
        final cloneReq = err.requestOptions;
        cloneReq.headers['Authorization'] = 'Bearer $newAccessToken';

        try {
          final response = await dio.fetch(cloneReq);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  // 중복 리프레시 방지 로직
  Future<String?> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) {
      _refreshCompleter!.complete(null);
      _refreshCompleter = null;
      return null;
    }

    try {
      final response = await dio.post(
        'https://front-mission.bigs.or.kr/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await TokenStorage.saveTokens(newAccessToken, newRefreshToken);

      _refreshCompleter!.complete(newAccessToken);
      return newAccessToken;
    } catch (e) {
      await TokenStorage.clear();
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}