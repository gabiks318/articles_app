import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/article.dart';

part "api_service.g.dart";

@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("everything")
  Future<ArticleResponse> getArticles(
      {@Query("q") String? query,
      @Query("from") String? fromDate,
      @Query("sortBy") String sortBy = "publishedAt",
      @Query("language") String language = "en",
      @Query("apiKey") String? apiKey});
}

@JsonSerializable()
class ArticleResponse {
  List<Article> articles;

  ArticleResponse({required this.articles});

  factory ArticleResponse.fromJson(Map<String, dynamic> json) => _$ArticleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);
}
