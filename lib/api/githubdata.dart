import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

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

// RestClient.g.dart에서 이 부분만 복사했음.
// @RestApi(baseUrl: "")가 정의된 파일에서 시작.... <= 레트로핏 Interface 정의파일
// 0. 같은 파일에 데이터정의
// 1. fromJson. toJson 함수를 정의하되 생성될 함수명을 _$로 대입(에러발생무시)
// 2. flutter pub run build_runner build
// 3. data 정의부분만 파일로 분리
// 4. g.dart 파일에서 fromJson, toJson만 잘라내서 Data정의된 파일에 붙이기
User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    login: json['login'] as String?,
    repos: json['repos'] as int?,
    gists: json['gists'] as int?,
    followers: json['followers'] as int?,
  )
    ..following = json['following'] as int?
    ..bio = json['bio'] as String?
    ..avatar_url = json['avatar_url'] as String?;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'login': instance.login,
  'repos': instance.repos,
  'gists': instance.gists,
  'followers': instance.followers,
  'following': instance.following,
  'bio': instance.bio,
  'avatar_url': instance.avatar_url,
};

@JsonSerializable()
class Repo {
  int? id;
  String? name;

  String? full_name;
  int stargazers_count;
  int size;
  String? description;
  String? clone_url;
  Owner? owner;

  Repo({
    this.id, this.name, this.full_name,
    required this.stargazers_count,  required  this.size,
    this.description, this.clone_url, this.owner});

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> Function(Repo instance) toJson() => _$RepoToJson;
}

@JsonSerializable()
class Owner{
  String? html_url;

  Owner({this.html_url});
  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> Function(Owner instance) toJson() => _$OwnerToJson;
}

Repo _$RepoFromJson(Map<String, dynamic> json) {
  return Repo(
    id: json['id'] as int?,
    name: json['name'] as String?,
    full_name: json['full_name'] as String?,
    stargazers_count: json['stargazers_count'] as int,
    size: json['size'] as int,
    description: json['description'] as String?,
    clone_url: json['clone_url'] as String?,
    owner: json['owner'] == null
        ? null
        : Owner.fromJson(json['owner'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'full_name': instance.full_name,
  'stargazers_count': instance.stargazers_count,
  'size': instance.size,
  'description': instance.description,
  'clone_url': instance.clone_url,
  'owner': instance.owner,
};

Owner _$OwnerFromJson(Map<String, dynamic> json) {
  return Owner(
    html_url: json['html_url'] as String?,
  );
}

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
  'html_url': instance.html_url,
};