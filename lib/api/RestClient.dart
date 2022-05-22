import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'githubdata.dart';

// 0. 참고사이트(레트로핏, dio)
// https://pub.dev/packages/retrofit
// https://pub.dev/packages/dio

// 1. retrofit API가 선언된 파일(이곳)에서 데이터 정의
// 정의 시 @JsonSerializable()으로 선언하고
// 데이터를 정의하며
// fromJson(), fromJson() 함수를 같이 선언 후, 대입하는 구조로 구현한다.

// ex)
// @JsonSerializable()
// class User {
//   String? login;
//   int? repos;
//   int? gists;
//   int? followers;
//   int? following;
//   String? bio;
//   String? avatar_url;
//
//   User({this.login, this.repos, this.gists, this.followers});
//
//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//   Map<String, dynamic> Function(User instance) toJson() => _$UserToJson;
//
// }


// 2. retrofit 제너레이트 코드를 사용하기 위해
// part '파일명.g.dart'
// 를 수동으로 정의

// 3. 터미널에서 실행
// flutter pub run build_runner build

// 4. 이대로 사용해도 되지만, 정의된 데이터를 따로 파일로 관리해도 됨.
// 단, fromJson(), fromJson() 함수를 정의한 내용을 [파일명.g.dart]에서
// 가져와서 같은 파일에 기술해야 한다.

part 'RestClient.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/users/{user}")
  Future<User>  getUser(@Path("user") String user);

  @GET("/users/{user}/repos")
  Future<List<Repo>> listRepos(@Path("user") String user);

  @GET("/users/{user}/repos")
  Future<List<Repo>> listReposWithPage(@Path("user") String user , @Query("page") int page);

}






