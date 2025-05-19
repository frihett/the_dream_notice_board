import 'package:flutter/material.dart';
import 'package:the_dream_notice_board/data/models/board_model.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_list_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_categories_usecase.dart';

class BoardViewModel extends ChangeNotifier {
  final GetBoardListUseCase getBoardListUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  Map<String, String> categories = {};
  String selectedCategory = 'ALL';

  List<Board> boards = [];
  List<Board> filteredBoards = [];

  bool isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _page = 0;
  final int _pageSize = 10;

  String? error;

  BoardViewModel({
    required this.getBoardListUseCase,
    required this.getCategoriesUseCase,
  });

  Future<void> fetchBoards() async {
    isLoading = true;
    _page = 0;
    _hasMore = true;
    boards.clear();
    notifyListeners();

    try {
      final newBoards =
          await getBoardListUseCase.execute(page: _page, size: _pageSize);
      boards = newBoards;
      _hasMore = newBoards.length == _pageSize;
      _filterBoards();
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || !_hasMore) return;
    _isFetchingMore = true;
    _page++;

    try {
      final newBoards =
          await getBoardListUseCase.execute(page: _page, size: _pageSize);
      boards.addAll(newBoards);
      _hasMore = newBoards.length == _pageSize;
      _filterBoards();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }

    _isFetchingMore = false;
  }

  Future<void> fetchCategories() async {
    try {
      categories = await getCategoriesUseCase.execute();
      categories = {'ALL': '전체', ...categories};
      notifyListeners();
    } catch (e) {
      error = '카테고리 로딩 실패';
    }
  }

  void setCategory(String category) {
    selectedCategory = category;
    _filterBoards();
    notifyListeners();
  }

  void _filterBoards() {
    if (selectedCategory == 'ALL') {
      filteredBoards = boards;
    } else {
      filteredBoards =
          boards.where((board) => board.category == selectedCategory).toList();
    }
  }
}
