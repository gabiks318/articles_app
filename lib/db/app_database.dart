import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'article_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ArticleTable])
abstract class AppDatabase extends _$MyDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ArticleEntry>> getAllArticles() => select(articles).get();
  Future insertArticle(ArticleEntry article) => into(articles).insert(article);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder, 'articles.db'));
    return NativeDatabase(file);
  });
}
