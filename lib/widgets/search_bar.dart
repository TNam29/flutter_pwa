import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
	final void Function(String) onSearch;

	const SearchBarWidget({required this.onSearch, super.key});

	@override
	Widget build(BuildContext context) {
		return TextField(
			decoration: InputDecoration(
				prefixIcon: const Icon(Icons.search),
				hintText: 'Tìm kiếm tên hoặc nguyên liệu...',
				border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
			),
			onChanged: onSearch,
		);
	}
}
