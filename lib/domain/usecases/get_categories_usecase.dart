import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class GetCategoriesUseCase {
  final BoardRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Map<String, String>> execute() {
    return repository.getCategories();
  }
}
