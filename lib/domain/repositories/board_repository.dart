import 'dart:io';

import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';

abstract class BoardRepository {
  Future<List<Board>> getBoards({int page, int size});

  Future<int> createBoard(CreateBoardRequest request, {File? image});

  Future<Map<String, String>> getCategories();
}
