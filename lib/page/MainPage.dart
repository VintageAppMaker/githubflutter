import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:githubflutter/util/Util.dart';

import '/api/RestClient.dart';
import '/util/Ui.dart';

import '/api/githubdata.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 통신처리
  bool bLoading = false;
  // 리스트처리
  List<dynamic> display_lst = new List.empty(growable: true);
  int lstCount = 0;
  static int FIRST_PAGE = 1;
  int pagecount = FIRST_PAGE;

  // scroll
  final ScrollController _scrollController = ScrollController();

  // Rainbow?
  final dio = Dio();

  // 계정입력
  String sAccount = "";

  // 생성
  @override
  void initState() {
    super.initState();

    // scroll bottom처리
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
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
  Future<User?> getUserProf(String sUser) async {
    final client = RestClient(dio);

    User? u = null;
    try {
      u = await client.getUser(sUser);
    } catch (e) {}

    return u;
  }

  // 처음 repo list 가져오기
  Future<List<Repo>> getRepoListFirst(String sUser) async {
    final client = RestClient(dio);
    List<Repo> lst = await client.listRepos(sUser);

    pagecount = FIRST_PAGE;

    return lst;
  }

  Future<List<Repo>> getRepoNext(String sUser, int page) async {
    final client = RestClient(dio);
    List<Repo> lst = await client.listReposWithPage(sUser, page);
    return lst;
  }

  void _getUserInfo(String sUser) async {
    setState(() {
      bLoading = true;
    });

    User? u = await getUserProf(sUser);
    // 통신에러
    if (u == null) {
      setState(() {
        bLoading = false;
      });

      return;
    }

    List<Repo> lst = await getRepoListFirst(sUser);

    setState(() {
      bLoading = false;

      display_lst.clear();

      // data 추가
      display_lst.add(u);
      display_lst.addAll(lst);

      // 화면갱신
      lstCount = lst.length;
    });
  }

  void _getNextPage(String sUser, int page) async {
    setState(() {
      bLoading = true;
    });

    List<Repo> lst = await getRepoNext(sUser, page);
    setState(() {
      bLoading = false;

      // data 추가
      display_lst.addAll(lst);

      // 화면갱신
      lstCount = display_lst.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Color(0xFF7F7F7F),
      appBar: BlankAppBar(),
      body: mainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          askAccountDialog(context, (value) {
            setState(() {
              sAccount = value;
            });
          }, () {
            setState(() {
              Navigator.pop(context);
            });
          }, () {
            setState(() {
              _getUserInfo(sAccount);
              Navigator.pop(context);
            });
          });
        }, //_getUserInfo,
        tooltip: 'get github info',
        child: const Icon(Icons.search),
      ),
    );
  }

  String makeStar(int n) {
    int MAX_SHOW = 10;
    if (n == 0) return "\uD83D\uDE36";
    if (n > MAX_SHOW) return "\uD83E\uDD29 X ${n}";
    String s = "";
    for (int i = 0; i < n; i++) {
      s = s + "⭐";
    }
    return s;
  }

  // main 화면
  Widget mainContent() {
    return Center(
      child: Stack(
        children: [
          if (sAccount.length > 0) makeAccountInfo() else makeNotice(),
          if (bLoading) showProgress()
        ],
      ),
    );
  }

  Widget makeAccountInfo() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: (constraints.maxWidth < 550) ? double.infinity : 550,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // user 정보
              Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    '$sAccount',
                    style: TextStyle(fontSize: 18, color: Color(0xFFD0CFCF)),
                  ))),

              SizedBox(height: 8.0),

              // repo 리스트 : Expanded로 감싸야 한다.
              Expanded(
                  child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (BuildContext, index) {
                  return makeItemCard(index);
                },
                itemCount: lstCount,
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                scrollDirection: Axis.vertical,
              ))
            ],
          ),
        );
      },
    );
  }

  // Repo 카드
  Widget makeItemCard(int index) {
    if (display_lst == null)
      return Text(
        '자료없음',
        style: Theme.of(context).textTheme.headline4,
      );

    if (display_lst[index] is Repo) {
      var repo = display_lst[index] as Repo;
      String sTitle = "${repo.full_name}";
      String sDesc = "${repo.description ?? ""}";

      return InkWell(
        child: Card(
          child: ListTile(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("$index", style: TextStyle(fontSize: 20))],
            ),
            title: Text(sTitle),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
                Text(sDesc),
                SizedBox(height: 8.0),
                Text("${makeStar(repo.stargazers_count)}")
              ],
            ),
          ),
        ),
        onTap: () {
          shareUrl(repo.clone_url ?? "");
        },
      );
    } else {
      // User Info
      User u = display_lst[index] as User;
      return showUserCard(u);
    }
  }

  // User Card
  Widget showUserCard(User u) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Color.fromRGBO(0xE7, 0xE7, 0xE7, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 18.0),
          Center(
              child: Container(
            padding: EdgeInsets.all(15),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(u.avatar_url ?? ""))),
          )),
          Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(u.login ?? "",
                      style: Theme.of(context).textTheme.headline2,
                      maxLines: 1),
                  SizedBox(height: 8.0),
                  Text(u.bio ?? ""),
                  Text("🤴 followers : ${u.followers}"),
                  Text("👨‍🎓 following : ${u.following}"),
                ],
              ))
        ],
      ),
    );
  }

  Widget makeNotice() {
    return Center(
        child: Container(
      width: double.infinity,
      color: Color(0xFF000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("⬜ 계정을 검색하세요",
              style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
          SizedBox(height: 8.0),
          Image.network(
              "https://avatars.githubusercontent.com/u/9919?s=200&v=4")
        ],
      ),
    ));
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
