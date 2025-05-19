import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/domain/usecases/delete_board_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_detail_usecase.dart';

class BoardDetailViewModel extends ChangeNotifier {
  final GetBoardDetailUseCase useCase;
  final DeleteBoardUseCase deleteUseCase;

  BoardDetail? board;
  bool isLoading = false;
  String? error;

  BoardDetailViewModel({required this.useCase, required this.deleteUseCase});

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

  Future<void> deleteBoard(int id) async {
    try {
      await deleteUseCase.execute(id);
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }
}
