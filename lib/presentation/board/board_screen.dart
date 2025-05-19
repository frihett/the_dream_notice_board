import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/board/board_view_model.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BoardViewModel>().fetchBoards());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BoardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, '/write');
              vm.fetchBoards();
            },
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('에러: ${vm.error}'))
              : ListView.builder(
                  itemCount: vm.boards.length,
                  itemBuilder: (context, index) {
                    final board = vm.boards[index];
                    return ListTile(
                      title: Text(board.title),
                      subtitle: Text('${board.category} • ${board.createdAt}'),
                    );
                  },
                ),
    );
  }
}
