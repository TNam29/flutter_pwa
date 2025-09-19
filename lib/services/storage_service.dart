import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class StorageService {
  static const String _recipesKey = 'recipes';

  // Lấy danh sách công thức
  static Future<List<Recipe>> getRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String recipesString = prefs.getString(_recipesKey) ?? '[]';
    
    try {
      final List<dynamic> recipesList = json.decode(recipesString);
      return recipesList.map((item) => Recipe.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Lưu danh sách công thức
  static Future<void> saveRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> recipesMapList = 
        recipes.map((recipe) => recipe.toMap()).toList();
    await prefs.setString(_recipesKey, json.encode(recipesMapList));
  }

  // Thêm công thức mới
  static Future<void> addRecipe(Recipe recipe) async {
    final List<Recipe> recipes = await getRecipes();
    recipes.add(recipe);
    await saveRecipes(recipes);
  }

  // Cập nhật công thức
  static Future<void> updateRecipe(Recipe updatedRecipe) async {
    final List<Recipe> recipes = await getRecipes();
    final int index = recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      recipes[index] = updatedRecipe;
      await saveRecipes(recipes);
    }
  }

  // Xóa công thức
  static Future<void> deleteRecipe(String id) async {
    final List<Recipe> recipes = await getRecipes();
    recipes.removeWhere((r) => r.id == id);
    await saveRecipes(recipes);
  }

  // Tìm kiếm công thức
  static Future<List<Recipe>> searchRecipes(String query) async {
    final List<Recipe> recipes = await getRecipes();
    if (query.isEmpty) return recipes;
    
    return recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase()) ||
          recipe.ingredients.any((ingredient) => 
              ingredient.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}