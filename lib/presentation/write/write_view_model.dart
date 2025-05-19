import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/domain/usecases/create_board_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_categories_usecase.dart';

class WriteViewModel extends ChangeNotifier {
  final CreateBoardUseCase useCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  bool isLoading = false;
  String? error;

  Map<String, String> categories = {};
  String selectedCategory = 'NOTICE';

  WriteViewModel({required this.useCase, required this.getCategoriesUseCase});

  Future<void> fetchCategories() async {
    try {
      categories = await getCategoriesUseCase.execute();
      selectedCategory = categories.keys.first;
      notifyListeners();
    } catch (e) {
      error = '카테고리 로딩 실패';
    }
  }

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
