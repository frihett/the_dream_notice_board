class CreateBoardRequest {
  final String title;
  final String content;
  final String category;

  CreateBoardRequest({
    required this.title,
    required this.content,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'category': category,
  };
}