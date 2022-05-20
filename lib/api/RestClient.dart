import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'githubdata.dart';

// 1. 참고사이트(레트로핏, dio)
// https://pub.dev/packages/retrofit
// https://pub.dev/packages/dio

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

  @GET("/users/{user}")
  Future<User>  getUser(@Path("user") String user);

  @GET("/users/{user}/repos")
  Future<List<Repo>> listRepos(@Path("user") String user);

  @GET("/users/{user}/repos")
  Future<List<Repo>> listReposWithPage(@Path("user") String user , @Query("page") int page);

}






