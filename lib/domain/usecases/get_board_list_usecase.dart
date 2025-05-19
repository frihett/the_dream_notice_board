import 'package:the_dream_notice_board/data/models/board_model.dart';
import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class GetBoardListUseCase {
  final BoardRepository repository;

  GetBoardListUseCase({required this.repository});

  Future<List<Board>> execute({int page = 0, int size = 10}) {
    return repository.getBoards(page: page, size: size);
  }
}