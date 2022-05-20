import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'RestClient.dart';
import '/util/dialog.dart';

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

  // Rainbow?
  final dio = Dio();

  // 계정입력
  String sAccount ="";

  Future<User> getUserProf (String sUser) async{
    final client = RestClient(dio);

    User u = await client.getUser(sUser);
    return u;
  }

  void _getUserInfo(String sUser) async{
    User u = await getUserProf(sUser);
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
      body: mainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          askAccountDialog(context, (value){
            setState(() {
              sAccount = value;
            });
          }, (){
            setState(() {
              Navigator.pop(context);
            });

          },(){
            setState(() {
              _getUserInfo(sAccount);
              Navigator.pop(context);
            });
          });}, //_getUserInfo,
        tooltip: 'get github info',
        child: const Icon(Icons.search),
      ),
    );
  }

  // main 화면
  Widget mainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            '$_displayText',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }


}
