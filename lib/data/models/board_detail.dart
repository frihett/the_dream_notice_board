class BoardDetail {
  final int id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String createdAt;

  BoardDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.imageUrl,
  });

  factory BoardDetail.fromJson(Map<String, dynamic> json) {
    return BoardDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['boardCategory'] ?? json['category'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }
}
