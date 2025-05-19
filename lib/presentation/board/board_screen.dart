import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/board/board_view_model.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<BoardViewModel>();
    Future.microtask(() async {
      await vm.fetchCategories();
      await vm.fetchBoards();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<BoardViewModel>().fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BoardViewModel>();
    final categories = vm.categories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('게시판'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/write');
                  vm.fetchBoards();
                  vm.setCategory('ALL');
                },
              ),
            ],
            bottom: categories.isEmpty
                ? null
                : TabBar(
                    isScrollable: true,
                    onTap: (index) {
                      final categoryKey = categories.keys.elementAt(index);
                      vm.setCategory(categoryKey);
                    },
                    tabs: categories.values
                        .map((name) => Tab(text: name))
                        .toList(),
                  ),
          ),
          body: vm.isLoading && vm.boards.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: vm.filteredBoards.length + 1,
                  itemBuilder: (context, index) {
                    if (index < vm.filteredBoards.length) {
                      final board = vm.filteredBoards[index];
                      return ListTile(
                        title: Text(board.title),
                        subtitle:
                            Text('${board.category} • ${board.createdAt}'),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/board_detail',
                              arguments: board.id);
                          vm.fetchBoards();
                        },
                      );
                    } else {
                      return vm.isLoading
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ))
                          : const SizedBox.shrink();
                    }
                  },
                )),
    );
  }
}
