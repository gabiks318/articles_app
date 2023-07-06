import '../models/article.dart';

class ApiStates {
  List<Article> articles;
  ApiStates({this.articles = const []});
}

class InitialState extends ApiStates {}

class LoadingState extends ApiStates {}

class LoadedState extends ApiStates {
  LoadedState({required List<Article> articles}) : super(articles: articles);
}

class ErrorState extends ApiStates {
  final String errorMessage;

  ErrorState(this.errorMessage);
}
