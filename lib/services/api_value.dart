// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:dio/dio.dart';

class APIvalue {
  static String url = 'https://shareittofriends.com/';

  //=======================================Auth=====================================================

  String loginURL = "${url}demo/flutter/Login.php";

  String registerURL = "${url}demo/flutter/Register.php";

  Dio dio = Dio();

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> login(String email, String password) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('email', email),
        MapEntry('password', password),
      ]);

      Response response = await dio.post(loginURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return e.response?.data;
        }
      }
      return null;
    }
  }

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> register(
      String name, String email, String mobile, String password) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('name', name),
        MapEntry('email', email),
        MapEntry('mobile', mobile),
        MapEntry('password', password),
      ]);

      Response response = await dio.post(registerURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return e.response?.data;
        }
      }
      return null;
    }
  }

//---------------------------------------------------------------------------------------------------------------
}

APIvalue apiValue = APIvalue();
