class Recipe {
  String id;
  String name;
  List<String> ingredients;
  String instructions;
  String? imageUrl;
  DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    required this.createdAt,
  });

  // Chuyển đổi từ Map sang Recipe
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: List<String>.from(map['ingredients']),
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Chuyển đổi từ Recipe sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}