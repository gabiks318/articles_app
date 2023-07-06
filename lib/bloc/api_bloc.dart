import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/article.dart';
import '../service/api_service.dart';
import 'api_events.dart';
import 'api_states.dart';

class ApiBloc extends Bloc<ApiEvent, ApiStates> {
  List<Article> articles = [];
  ApiBloc() : super(InitialState()) {
    on<FetchArticlesEvent>((ApiEvent event, Emitter<ApiStates> emit) async {
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
    });
    res.shuffle();
    return res;
  }
}
