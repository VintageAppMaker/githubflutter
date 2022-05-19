import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

// 1. 참고사이트
// https://pub.dev/packages/retrofit

// 2. 레트로핏 stub 코드 제너레이트 방법
// 소스 수정시 수동으로 해주어야 함

//# dart
// pub run build_runner build
//
// # flutter
// flutter pub run build_runner build
part 'RestClient.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;


  // 코루틴 내에서 간편하게 사용하기 위한 suspend를 이용한 API
  @GET("/users/{user}")
  Future<User>  getUser(@Path("user") String user);

}

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

