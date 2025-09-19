import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe.dart';
import 'package:flutter_recipe_book/pages/recipe_detail_page.dart';

class RecipeCard extends StatelessWidget {
	final Recipe recipe;
	final VoidCallback? onUpdate;

	const RecipeCard({required this.recipe, this.onUpdate, super.key});

	@override
	Widget build(BuildContext context) {
		return Card(
			clipBehavior: Clip.hardEdge,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
			child: InkWell(
				onTap: () async {
					final result = await Navigator.of(context).push<bool>(
						MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe, onDeleted: onUpdate)),
					);
					if (result == true && onUpdate != null) onUpdate!();
				},
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// Image area (fixed aspect ratio for consistent tiles)
						AspectRatio(
							aspectRatio: 4 / 3,
							child: recipe.imageUrl != null
									? Image.network(
											recipe.imageUrl!,
											fit: BoxFit.cover,
											width: double.infinity,
											errorBuilder: (_, __, ___) => Container(
												color: Colors.grey[200],
												child: const Icon(Icons.broken_image, size: 48),
											),
										)
									: Container(color: Colors.grey[100], child: const Center(child: Icon(Icons.restaurant_menu, size: 36))),
						),
						Padding(
							padding: const EdgeInsets.all(12.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(recipe.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
									const SizedBox(height: 8),
									Text(
										recipe.ingredients.join(', '),
										style: Theme.of(context).textTheme.bodySmall,
										maxLines: 3,
										overflow: TextOverflow.ellipsis,
									),
								],
							),
						),
					],
				),
			),
		);
	}
}
