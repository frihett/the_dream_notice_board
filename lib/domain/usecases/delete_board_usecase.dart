import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class DeleteBoardUseCase {
  final BoardRepository repository;

  DeleteBoardUseCase({required this.repository});

  Future<void> execute(int id) {
    return repository.deleteBoard(id);
  }
}
