import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:articles/models/article.dart';
import 'package:articles/service/api_service.dart';
import 'package:articles/widgets/article_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];

  String lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

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

  FutureBuilder _body() {
    return FutureBuilder<List<Article>>(
      future: fetchArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          articles = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                    itemCount: articles.length,
                    separatorBuilder: (context, index) {
                      // Add a divider between list tiles
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Color(0xFF3F2305),
                          thickness: 1.0,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(13),
                        child: ArticleItem(title: articles[index].title, content: articles[index].content),
                      );
                    }),
              ),
              Container(
                  height: 80.0,
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [BottomButton(onPressed: _refreshArticles, text: 'Refresh'), BottomButton(text: "Clear", onPressed: _clearArticles)],
                  ))
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _refreshArticles() {
    /* setState(() {
      articles = [
        ArticleModel(title: "Title 1", content: lorem),
        ArticleModel(title: "Title 2", content: lorem),
        ArticleModel(title: "Title 3", content: lorem),
        ArticleModel(title: "Title 4", content: lorem),
        ArticleModel(title: "Title 5", content: lorem),
      ];
    }); */
  }

  void _clearArticles() {
    setState(() {
      articles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('What\'s New', style: Theme.of(context).textTheme.headlineLarge),
          backgroundColor: Color(0xFF122620),
          centerTitle: true,
        ),
        body: _body());
  }
}
