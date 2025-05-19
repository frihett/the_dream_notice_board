import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/presentation/write/write_view_model.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _category = 'NOTICE';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WriteViewModel>().fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WriteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('글 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: vm.selectedCategory,
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
                          final id = await vm.createBoard(
                            _titleController.text,
                            _contentController.text,
                            _category,
                            image: _selectedImage,
                          );
                          if (id != null && context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('작성 완료'),
                    ),
              if (vm.error != null)
                Text(vm.error!, style: const TextStyle(color: Colors.red))
            ],
          ),
        ),
      ),
    );
  }
}
