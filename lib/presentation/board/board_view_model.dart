import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_list_usecase.dart';

class BoardViewModel extends ChangeNotifier {
  final GetBoardListUseCase getBoardListUseCase;

  List<Board> boards = [];
  bool isLoading = false;
  String? error;

  BoardViewModel({required this.getBoardListUseCase});

  Future<void> fetchBoards() async {
    isLoading = true;
    notifyListeners();

    try {
      boards = await getBoardListUseCase.execute();
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}