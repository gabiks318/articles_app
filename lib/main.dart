import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './db/app_database.dart';
import 'bloc/api_bloc.dart';
import 'screens/home_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  final database = AppDatabase();
  database.connect();

  runApp(BlocProvider(create: (context) => ApiBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'OpenSans',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF122620), fontSize: 20),
          bodySmall: TextStyle(color: Color(0xFF122620), fontSize: 16),
          headlineLarge: TextStyle(color: Color(0xFFF5F5F5), fontSize: 20),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
