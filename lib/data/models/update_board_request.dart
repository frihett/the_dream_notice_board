class UpdateBoardRequest {
  final String title;
  final String content;
  final String category;

  UpdateBoardRequest({
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