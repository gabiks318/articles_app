import 'package:articles/db/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../db/article_table.dart';
import '../models/article.dart';
import '../service/api_service.dart';
import 'api_events.dart';
import 'api_states.dart';

class ApiBloc extends Bloc<ApiEvent, ApiStates> {
  List<Article> articles = [];
  final AppDatabase database = AppDatabase();

  ApiBloc() : super(InitialState()) {
    // load articles from database

    on<FetchArticlesEvent>((ApiEvent event, Emitter<ApiStates> emit) async {
      loadArticlesFromDatabase();
      final List<Article> res = await fetchArticles();
      res.forEach((element) {
        if (!articles.contains(element)) {
          articles.add(element);
        }
      });
      emit(LoadedState(articles: articles));
      try {
        emit(LoadingState());

        final List<Article> res = await fetchArticles();
        emit(LoadedState(articles: res));
      } catch (error) {
        emit(ErrorState("Couldn't fetch articles. Is the device online?"));
      }
    });
    on<ClearArticlesEvent>((ApiEvent event, Emitter<ApiStates> emit) async {
      emit(LoadingState());

      emit(InitialState());
    });
  }

  void loadArticlesFromDatabase() async {
    try {
      emit(LoadingState());

      final List<ArticleEntry> res = await database.getAllArticles();
      final List<Article> articles = [];
      res.forEach((element) => articles.add(Article(title: element.title, content: element.content)));

      emit(LoadedState(articles: articles));
    } catch (error) {
      emit(ErrorState("Couldn't load articles from the database."));
    }
  }

  Future<List<Article>> fetchArticles() async {
    final dio = Dio();
    final apiService = ApiService(dio);
    final List<ArticleResponse> responses = await Future.wait([
      /* apiService.getArticles(apiKey: dotenv.env['API_KEY'], fromDate: DateFormat("yyyy-MM-dd").format(DateTime.now()), query: "tesla"),
      apiService.getArticles(apiKey: dotenv.env['API_KEY'], fromDate: DateFormat("yyyy-MM-dd").format(DateTime.now()), query: "microsoft") */
      apiService.getArticles(apiKey: dotenv.env['API_KEY'], fromDate: "2023-07-05", query: "tesla"),
      apiService.getArticles(apiKey: dotenv.env['API_KEY'], fromDate: "2023-07-05", query: "microsoft")
    ]);
    List<Article> res = [];
    responses.forEach((element) {
      res.addAll(element.articles);
      // save articles to database
      element.articles.forEach((article) async {
        await database.insertArticle(ArticleEntry(title: article.title, content: article.content));
      });
    });
    res.shuffle();
    return res;
  }
}
