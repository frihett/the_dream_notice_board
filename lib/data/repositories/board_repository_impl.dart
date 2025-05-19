import 'dart:io';

import 'package:the_dream_notice_board/data/datasources/board_remote_datasource.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';
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
}
