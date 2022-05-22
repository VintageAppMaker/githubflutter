# githubflutter
> flutter로 만들어보는 github api 예제

1. 통신은 dio와 retrofit 사용
2. 사용시 다음과 같은 방법으로 코드를 생성해야 함

~~~dart
// @RestApi(baseUrl: "")가 정의된 파일에서 시작.... <= 레트로핏 Interface 정의파일 (예제에서는 RestClient.dart)

// 0. 참고사이트(레트로핏, dio)
// https://pub.dev/packages/retrofit
// https://pub.dev/packages/dio

1. retrofit API가 선언된 파일(이곳)에서 데이터 정의
정의 시 @JsonSerializable()으로 선언하고
데이터를 정의하며  
fromJson(), fromJson() 함수를 같이 선언 후, 대입하는 구조로 구현한다. 

// ex)
@JsonSerializable()
class User {
  String? login;
  int? repos;
  int? gists;
  int? followers;
  int? following;
  String? bio;
  String? avatar_url;

  User({this.login, this.repos, this.gists, this.followers});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> Function(User instance) toJson() => _$UserToJson;

}


2. retrofit 제너레이트 코드를 사용하기 위해 
part '파일명.g.dart'
를 수동으로 정의 

3. 터미널에서 실행
flutter pub run build_runner build

4. 이대로 사용해도 되지만, 정의된 데이터를 따로 파일로 관리해도 됨.
단, fromJson(), fromJson() 함수를 정의한 내용을 [파일명.g.dart]에서 
가져와서 같은 파일에 기술해야 한다. 

[](/lib/githubdata.dart)

~~~

3. github api에 사용된 예제는 인증키가 없으므로 서버에서 종종 에러를 발생할 것임.

4. web 빌드화면

![](web.gif)

5. desktop 빌드화면

![](desktop.gif)

6. Android 빌드화면

![](android.gif)
