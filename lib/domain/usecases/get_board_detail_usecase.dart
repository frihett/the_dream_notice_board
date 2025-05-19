import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class GetBoardDetailUseCase {
  final BoardRepository repository;

  GetBoardDetailUseCase({required this.repository});

  Future<BoardDetail> execute(int id) {
    return repository.getBoardDetail(id);
  }
}
