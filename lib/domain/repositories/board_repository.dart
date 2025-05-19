import 'dart:io';

import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';
import 'package:the_dream_notice_board/data/models/update_board_request.dart';

abstract class BoardRepository {
  Future<List<Board>> getBoards({int page, int size});

  Future<int> createBoard(CreateBoardRequest request, {File? image});

  Future<Map<String, String>> getCategories();

  Future<BoardDetail> getBoardDetail(int id);

  Future<void> updateBoard(int id, UpdateBoardRequest request, {File? image});
}
