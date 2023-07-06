import 'package:drift/drift.dart';

class ArticleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
}

class ArticleEntry{
  final int id;
  final String title;
  final String content;

  ArticleEntry({required this.id, required this.title, required this.content});
}