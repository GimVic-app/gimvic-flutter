import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gimvic_flutter/settings.dart';

const apiUrl = 'http://178.128.205.197/';

final Dio _dio = new Dio(new Options(
    baseUrl: apiUrl,
    responseType: ResponseType.JSON,
    contentType: ContentType.parse('application/json')));

Future _getRequest(String name, Map<String, dynamic> params) async {
  Response response = await _dio.get(name, data: params);

  if (response.statusCode != 200) {
    throw FormatException(
        'Https status error. Response status code ${response.statusCode}');
  }
  return json.decode(response.data);
}

Future<Map<String, Object>> getData() async {
  Map data = await _getRequest('pridobi_javascript_object_notation', {
    'token': sharedPreferences.getString('token')
  });
  return data;
}

Future<Map<String, Object>> loginUser(String username, String password) async {
  Map data = await _getRequest('prijavi_se_v_aplikacijo', {
    'username': username,
    'password': password
  });

  return data;
}