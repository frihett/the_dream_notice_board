import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/data/models/update_board_request.dart';
import 'package:the_dream_notice_board/domain/usecases/get_categories_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/update_board_usecase.dart';

class EditViewModel extends ChangeNotifier {
  final UpdateBoardUseCase updateUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  bool isLoading = false;
  String? error;

  Map<String, String> categories = {};
  String selectedCategory = 'NOTICE';

  EditViewModel({
    required this.updateUseCase,
    required this.getCategoriesUseCase,
  });

  Future<void> fetchCategories() async {
    try {
      categories = await getCategoriesUseCase.execute();
      categories = {'NOTICE': '공지사항', ...categories}; // 기본값 포함
      notifyListeners();
    } catch (e) {
      error = '카테고리 로딩 실패: $e';
      notifyListeners();
    }
  }

  Future<bool> updateBoard({
    required int id,
    required String title,
    required String content,
    required String category,
    File? image,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = UpdateBoardRequest(
        title: title,
        content: content,
        category: category,
      );
      await updateUseCase.execute(id, request, image: image);
      error = null;
      return true;
    } catch (e) {
      error = '글 수정 실패: $e';
      print(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}