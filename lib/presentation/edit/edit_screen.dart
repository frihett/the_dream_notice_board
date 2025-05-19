import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/presentation/edit/edit_view_model.dart';

class EditBoardScreen extends StatefulWidget {
  final BoardDetail board;

  const EditBoardScreen({super.key, required this.board});

  @override
  State<EditBoardScreen> createState() => _EditBoardScreenState();
}

class _EditBoardScreenState extends State<EditBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late String _category;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.board.title);
    _contentController = TextEditingController(text: widget.board.content);
    _category = widget.board.category;

    Future.microtask(() => context.read<EditViewModel>().fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('글 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                items: vm.categories.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (val) => val == null || val.isEmpty ? '제목 입력' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
                validator: (val) => val == null || val.isEmpty ? '내용 입력' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _selectedImage = File(picked.path));
                  }
                },
                child: const Text('이미지 선택'),
              ),
              const SizedBox(height: 12),
              vm.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await vm.updateBoard(
                            id: widget.board.id,
                            title: _titleController.text,
                            content: _contentController.text,
                            category: _category,
                            image: _selectedImage,
                          );
                          if (success && context.mounted) {
                            Navigator.pushNamed(context, '/board_detail',
                                arguments: widget.board.id);
                          }
                        }
                      },
                      child: const Text('수정 완료'),
                    ),
              if (vm.error != null)
                Text(vm.error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
