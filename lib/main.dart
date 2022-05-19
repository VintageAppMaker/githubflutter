import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'RestClient.dart';

void main() {
  runApp(const GithubApp());
}

class GithubApp extends StatelessWidget {
  const GithubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainPage(title: 'Flutter github api test'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _displayText = "";
  final dio = Dio(); // Rainbow?

  Future<User> getUserProf () async{
    final client = RestClient(dio);

    User u = await client.getUser("google");
    return u;
  }

  void _getUserInfo() async{
    User u = await getUserProf();
    setState(() {

      // client.getUser("google").then((it) =>
      //     _displayText = "${it.bio}"
      // );
      _displayText = "${u.bio}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_displayText',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserInfo,
        tooltip: 'get github info',
        child: const Icon(Icons.search),
      ),
    );
  }
}
