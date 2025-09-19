import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe.dart';
import 'package:flutter_recipe_book/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class AddRecipePage extends StatefulWidget {
	final Recipe? existing;

	const AddRecipePage({this.existing, super.key});

	@override
	State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
	final _formKey = GlobalKey<FormState>();
	final _nameCtrl = TextEditingController();
	final _ingredientsCtrl = TextEditingController();
	final _instrCtrl = TextEditingController();
	final _imageCtrl = TextEditingController();

	bool get isEditing => widget.existing != null;

	@override
	void dispose() {
		_nameCtrl.dispose();
		_ingredientsCtrl.dispose();
		_instrCtrl.dispose();
			_imageCtrl.dispose();
		super.dispose();
	}

	Future<void> _save() async {
		if (!_formKey.currentState!.validate()) return;
			if (isEditing) {
				final updated = Recipe(
					id: widget.existing!.id,
					name: _nameCtrl.text,
					ingredients: _ingredientsCtrl.text.split(',').map((s) => s.trim()).toList(),
					instructions: _instrCtrl.text,
					imageUrl: _imageCtrl.text.isEmpty ? null : _imageCtrl.text,
					createdAt: widget.existing!.createdAt,
				);
				await StorageService.updateRecipe(updated);
			} else {
				final recipe = Recipe(
					id: const Uuid().v4(),
					name: _nameCtrl.text,
					ingredients: _ingredientsCtrl.text.split(',').map((s) => s.trim()).toList(),
					instructions: _instrCtrl.text,
					imageUrl: _imageCtrl.text.isEmpty ? null : _imageCtrl.text,
					createdAt: DateTime.now(),
				);
				await StorageService.addRecipe(recipe);
			}
		if (!mounted) return;
		Navigator.pop(context, true);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Thêm công thức')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
						child: Form(
					key: _formKey,
					child: Column(
						children: [
							TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Tên')),
									TextFormField(controller: _ingredientsCtrl, decoration: const InputDecoration(labelText: 'Nguyên liệu (phân tách bằng ,)')),
									TextFormField(controller: _imageCtrl, decoration: const InputDecoration(labelText: 'Image URL (tùy chọn)')),
									TextFormField(controller: _instrCtrl, decoration: const InputDecoration(labelText: 'Hướng dẫn'), maxLines: 4),
							const SizedBox(height: 16),
							ElevatedButton(onPressed: _save, child: const Text('Lưu')),
						],
					),
				),
			),
		);
	}
}
