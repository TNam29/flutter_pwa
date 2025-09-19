import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe.dart';
import 'package:flutter_recipe_book/services/storage_service.dart';
import 'package:flutter_recipe_book/widgets/recipe_card.dart';
import 'package:flutter_recipe_book/widgets/search_bar.dart';
import 'package:flutter_recipe_book/widgets/pwa_controls.dart';
import 'add_recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);
    final recipes = await StorageService.getRecipes();
    setState(() {
      _recipes = recipes;
      _filteredRecipes = recipes;
      _isLoading = false;
    });
  }

  void _searchRecipes(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredRecipes = _recipes);
    } else {
      final results = await StorageService.searchRecipes(query);
      setState(() => _filteredRecipes = results);
    }
  }

  void _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipePage()),
    );
    
    if (result == true) {
      _loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ Tay Nấu ăn'),
        actions: [
          const PwaControls(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddRecipe,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(onSearch: _searchRecipes),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRecipes.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có công thức nào.\nHãy thêm công thức mới!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : LayoutBuilder(builder: (context, constraints) {
                        final crossAxis = constraints.maxWidth >= 800 ? 3 : 2;
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxis,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: _filteredRecipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(
                              recipe: _filteredRecipes[index],
                              onUpdate: _loadRecipes,
                            );
                          },
                        );
                      }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}