import 'dart:io';

import 'package:the_dream_notice_board/data/datasources/board_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';
import 'package:the_dream_notice_board/data/models/update_board_request.dart';
import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardRemoteDataSource remoteDataSource;

  BoardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Board>> getBoards({int page = 0, int size = 10}) {
    return remoteDataSource.getBoards(page: page, size: size);
  }

  @override
  Future<int> createBoard(CreateBoardRequest request, {File? image}) {
    return remoteDataSource.createBoard(request, image: image);
  }

  @override
  Future<Map<String, String>> getCategories() {
    return remoteDataSource.getCategories();
  }

  Future<BoardDetail> getBoardDetail(int id) {
    return remoteDataSource.getBoardDetail(id);
  }

  @override
  Future<void> updateBoard(int id, UpdateBoardRequest request, {File? image}) {
    return remoteDataSource.updateBoard(id, request, image: image);
  }

  @override
  Future<void> deleteBoard(int id) {
    return remoteDataSource.deleteBoard(id);
  }
}
