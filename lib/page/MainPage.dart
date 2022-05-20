import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '/api/RestClient.dart';
import '/util/dialog.dart';

import '/api/githubdata.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // 리스트처리
  List<dynamic> display_lst = new List.empty(growable: true);
  int lstCount = 0;
  int pagecount = 0;

  // scroll
  final ScrollController _scrollController = ScrollController();

  // Rainbow?
  final dio = Dio();

  // 계정입력
  String sAccount ="";


  // 생성
  @override
  void initState() {
    super.initState();

    // scroll bottom처리
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent ){
        print("more");
        pagecount++;
        _getNextPage(sAccount, pagecount);
      }
    });
  }

  // 종료
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // 개인프로필
  Future<User> getUserProf (String sUser) async{
    final client = RestClient(dio);

    User u = await client.getUser(sUser);
    return u;
  }

  // 처음 repo list 가져오기
  Future<List<Repo>> getRepoListFirst(String sUser) async{
    final client = RestClient(dio);
    List<Repo> lst = await client.listRepos(sUser);

    pagecount = 0;

    return lst;
  }

  Future<List<Repo>> getRepoNext(String sUser, int page) async{
    final client = RestClient(dio);
    List<Repo> lst = await client.listReposWithPage(sUser, page);
    return lst;
  }

  void _getUserInfo(String sUser) async{
    User u = await getUserProf(sUser);
    List<Repo> lst = await getRepoListFirst(sUser);
    setState(() {

      display_lst.clear();

      // data 추가
      display_lst.add(u);
      display_lst.addAll(lst);

      // 화면갱신
      lstCount = lst.length;
    });
  }

  void _getNextPage(String sUser, int page) async{
    List<Repo> lst = await getRepoNext(sUser, page);
    setState(() {

      // data 추가
      display_lst.addAll(lst);

      // 화면갱신
      lstCount = display_lst.length;
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

          // user 정보
          Text(
            '$sAccount',
            style: Theme.of(context).textTheme.headline4,
          ),

          // repo 리스트 : Expanded로 감싸야 한다.
          Expanded(child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext, index){
              return makeRepoCard(index);
            },
            itemCount: lstCount,
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
          ))
        ],
      ),
    );
  }

  // Repo 카드
  Widget makeRepoCard(int index) {
    if(display_lst == null ) return Text(
      '자료없음',
      style: Theme.of(context).textTheme.headline4,
    );

    if(display_lst[index] is Repo){
      var repo = display_lst[index] as Repo;
      String sTitle = "${repo.full_name}";
      String sDesc = "${repo.description ?? ""}";

      return Card(
        child: ListTile(
          title: Text(sTitle),
          subtitle: Text(sDesc),
        ),
      );
    } else { // User Info
      User u = display_lst[index] as User;
      String sTitle = "${u.login}";
      String sDesc = "${u.bio ?? ""}";
      return Card(
        child: ListTile(
          title: Text(sTitle),
          subtitle: Text(sDesc),
        ),
      );
    }
  }
}

// 웹과 desktop에서 모바일처럼 터치 스크롤 지원하기 위함
class DeskScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
