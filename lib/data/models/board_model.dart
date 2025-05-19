class Board {
  final int id;
  final String title;
  final String category;
  final String createdAt;

  Board({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      createdAt: json['createdAt'],
    );
  }
}