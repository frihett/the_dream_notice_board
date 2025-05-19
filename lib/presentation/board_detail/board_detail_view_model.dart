import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_detail_usecase.dart';

class BoardDetailViewModel extends ChangeNotifier {
  final GetBoardDetailUseCase useCase;

  BoardDetail? board;
  bool isLoading = false;
  String? error;

  BoardDetailViewModel({required this.useCase});

  Future<void> fetchBoardDetail(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      board = await useCase.execute(id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
