import 'dart:io';

import 'package:the_dream_notice_board/data/models/update_board_request.dart';
import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class UpdateBoardUseCase {
  final BoardRepository repository;

  UpdateBoardUseCase({required this.repository});

  Future<void> execute(int id, UpdateBoardRequest request, {File? image}) {
    return repository.updateBoard(id, request, image: image);
  }
}
