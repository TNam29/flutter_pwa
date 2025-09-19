import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe.dart';
import 'package:flutter_recipe_book/services/storage_service.dart';
import 'add_recipe_page.dart';

class RecipeDetailPage extends StatefulWidget {
	final Recipe recipe;
	final VoidCallback? onDeleted;

	const RecipeDetailPage({required this.recipe, this.onDeleted, super.key});

	@override
	State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
		Future<void> _delete() async {
			await StorageService.deleteRecipe(widget.recipe.id);
			final onDeleted = widget.onDeleted;
			if (!mounted) return;
			if (onDeleted != null) onDeleted();
			Navigator.of(context).pop(true);
		}

	@override
	Widget build(BuildContext context) {
		final recipe = widget.recipe;
		return Scaffold(
			appBar: AppBar(
				title: Text(recipe.name),
				actions: [
								IconButton(
									icon: const Icon(Icons.edit),
												onPressed: () async {
													final navigator = Navigator.of(context);
													final onDeleted = widget.onDeleted;
													final res = await navigator.push<bool>(MaterialPageRoute(
														builder: (_) => AddRecipePage(existing: recipe),
													));
													if (res == true) {
														if (!mounted) return;
														// Reload updated recipe list by signaling parent
														if (onDeleted != null) onDeleted();
														navigator.pop(true);
													}
												},
								),
					IconButton(
						icon: const Icon(Icons.delete),
						onPressed: () => showDialog(
							context: context,
							builder: (ctx) => AlertDialog(
								title: const Text('Xóa công thức'),
								content: const Text('Bạn có chắc muốn xóa công thức này không?'),
								actions: [
																			TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
																			TextButton(onPressed: () {
																				  Navigator.of(ctx).pop();
																				  _delete();
																			}, child: const Text('Xóa')),
								],
							),
						),
					)
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: SingleChildScrollView(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							if (recipe.imageUrl != null) Center(child: Image.network(recipe.imageUrl!)),
							const SizedBox(height: 12),
							Text('Nguyên liệu', style: Theme.of(context).textTheme.titleMedium),
							const SizedBox(height: 6),
							...recipe.ingredients.map((i) => Text('- $i')),
							const SizedBox(height: 12),
							Text('Hướng dẫn', style: Theme.of(context).textTheme.titleMedium),
							const SizedBox(height: 6),
							Text(recipe.instructions),
						],
					),
				),
			),
		);
	}
}
