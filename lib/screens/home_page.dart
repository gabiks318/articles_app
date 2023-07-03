import 'package:articles/models/article.dart';
import 'package:flutter/material.dart';

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

  void _refreshArticles() {
    setState(() {
      articles = [
        Article(title: "Title 1", content: lorem),
        Article(title: "Title 2", content: lorem),
        Article(title: "Title 3", content: lorem),
        Article(title: "Title 4", content: lorem),
        Article(title: "Title 5", content: lorem),
      ];
    });
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
        body: Column(
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
                      child: ListTile(
                        title: Text(articles[index].title, style: Theme.of(context).textTheme.bodyLarge),
                        subtitle: Text(
                          articles[index].content,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
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
        ));
  }
}
