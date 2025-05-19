import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/board_detail/board_detail_view_model.dart';

class BoardDetailScreen extends StatefulWidget {
  final int boardId;

  const BoardDetailScreen({super.key, required this.boardId});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BoardDetailViewModel>().fetchBoardDetail(widget.boardId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BoardDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('게시글 상세')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('에러: ${vm.error}'))
              : vm.board == null
                  ? const Center(child: Text('게시글이 없습니다'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.board!.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${vm.board!.category} • ${vm.board!.createdAt}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vm.board!.content),
                                  if (vm.board!.imageUrl != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Image.network(
                                        'https://front-mission.bigs.or.kr${vm.board!.imageUrl!}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('수정'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/edit',
                                    arguments: vm.board,
                                  );
                                },
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('삭제'),
                                style: ElevatedButton.styleFrom(),
                                onPressed: () async {
                                  await vm.deleteBoard(vm.board!.id);
                                  Navigator.pushNamed(
                                    context,
                                    '/board',
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
    );
  }
}
