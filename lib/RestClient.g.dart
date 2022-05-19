// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestClient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.github.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<User> getUser(user) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<User>(
        Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, '/users/$user',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = User.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
