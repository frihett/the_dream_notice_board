import 'dart:io';

import 'package:the_dream_notice_board/data/models/CreateBoardRequest.dart';
import 'package:the_dream_notice_board/domain/repositories/board_repository.dart';

class CreateBoardUseCase {
  final BoardRepository repository;

  CreateBoardUseCase({required this.repository});

  Future<int> execute(CreateBoardRequest request, {File? image}) {
    return repository.createBoard(request, image: image);
  }
}
