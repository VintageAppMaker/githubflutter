import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:githubflutter/page/MainPage.dart';


void main() {
  runApp(const GithubApp());
}

class GithubApp extends StatelessWidget {
  const GithubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: DeskScrollBehavior(),
      title: 'Flutter github API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainPage(title: 'Flutter github api test'),
    );
  }
}

