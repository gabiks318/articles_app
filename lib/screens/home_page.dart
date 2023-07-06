import 'package:flutter/material.dart';

import 'package:articles/widgets/article_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/api_bloc.dart';
import '../bloc/api_events.dart';
import '../bloc/api_states.dart';
import '../widgets/bottom_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  BlocBuilder<ApiBloc, ApiStates> _body() {
    return BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
      if (state is LoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ErrorState) {
        return Center(child: Text(state.errorMessage));
      } else if (state is InitialState || state is LoadedState) {
        
        return Column(
          children: [
            Expanded(
              child: state is LoadedState
                  ? ListView.separated(
                      itemCount: state.articles.length,
                      separatorBuilder: (context, index) {
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
                          child: ArticleItem(title: state.articles[index].title, content: state.articles[index].content),
                        );
                      })
                  : const Center(child: Text("No articles to show")),
            ),
            Container(
                height: 80.0,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BottomButton(
                        onPressed: () {
                          BlocProvider.of<ApiBloc>(context).add(FetchArticlesEvent());
                        },
                        text: 'Refresh'),
                    BottomButton(
                      text: "Clear",
                      onPressed: () {
                        BlocProvider.of<ApiBloc>(context).add(ClearArticlesEvent());
                      },
                    )
                  ],
                ))
          ],
        );
      } else {
        return const Text("Something went wrong");
      }
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
