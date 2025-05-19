import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:the_dream_notice_board/data/datasources/board_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';

class BoardRemoteDataSourceImpl implements BoardRemoteDataSource {
  final Dio dio;

  BoardRemoteDataSourceImpl({required this.dio});

  // 글 조회
  @override
  Future<List<Board>> getBoards({int page = 0, int size = 10}) async {
    final response = await dio.get(
      'https://front-mission.bigs.or.kr/boards',
      queryParameters: {'page': page, 'size': size},
    );

    final List<dynamic> content = response.data['content'];
    return content.map((e) => Board.fromJson(e)).toList();
  }

  // 글 작성
  @override
  Future<int> createBoard(CreateBoardRequest request, {File? image}) async {
    final formData = FormData.fromMap({
      'request': MultipartFile.fromString(
        jsonEncode(request.toJson()),
        contentType: MediaType('application', 'json'),
      ),
      if (image != null)
        'file': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.post(
      'https://front-mission.bigs.or.kr/boards',
      data: formData,
    );

    return response.data['id'];
  }
}
