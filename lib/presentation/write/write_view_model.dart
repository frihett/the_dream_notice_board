import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/domain/usecases/create_board_usecase.dart';

class WriteViewModel extends ChangeNotifier {
  final CreateBoardUseCase useCase;

  bool isLoading = false;
  String? error;

  WriteViewModel({required this.useCase});

  Future<int?> createBoard(String title, String content, String category,
      {File? image}) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = CreateBoardRequest(
        title: title,
        content: content,
        category: category,
      );

      final id = await useCase.execute(request, image: image);
      error = null;
      return id;
    } catch (e) {
      error = e.toString();
      print(error);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
