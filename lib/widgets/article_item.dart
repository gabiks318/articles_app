import 'package:flutter/material.dart';

class ArticleItem extends StatelessWidget {
  final String title;
  final String content;

  const ArticleItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        content,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
