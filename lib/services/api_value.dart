// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:dio/dio.dart';

class APIvalue {
  static String url = 'https://shareittofriends.com/';

  //=======================================Auth=====================================================

  String loginURL = "${url}demo/flutter/Login.php";

  String registerURL = "${url}demo/flutter/Register.php";

  //=======================================product==================================================

  String fetchProductURL = "${url}demo/flutter/productList.php";

  String addProductURL = "${url}demo/flutter/addProduct.php";

  String deleteProductURL = "${url}demo/flutter/deleteProduct.php";

  String editProductURL = "${url}demo/flutter/editProduct.php";

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

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> getProduct() async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('user_login_token', SharedPreferencesHelper.gettoken()),
      ]);
      Response response = await dio.post(fetchProductURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> addProduct(
      String name, String moq, String price, String discount) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('user_login_token', SharedPreferencesHelper.gettoken()),
        MapEntry('name', name),
        MapEntry('moq', moq),
        MapEntry('price', price),
        MapEntry('discounted_price', discount),
      ]);

      Response response = await dio.post(addProductURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {}
      }
      return null;
    }
  }

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> deleteProduct(String id) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('user_login_token', SharedPreferencesHelper.gettoken()),
        MapEntry('id', id),
      ]);

      Response response = await dio.post(deleteProductURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {}
      }
      return null;
    }
  }

  //---------------------------------------------------------------------------------------------------------

  Future<dynamic> editProduct(
      String name, String moq, String price, String discount, String id) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('user_login_token', SharedPreferencesHelper.gettoken()),
        MapEntry('name', name),
        MapEntry('moq', moq),
        MapEntry('price', price),
        MapEntry('discounted_price', discount),
        MapEntry('id', id),
      ]);

      Response response = await dio.post(editProductURL, data: formData);
      if (response.statusCode == 200) {
        var output = response.data;
        return output;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {}
      }
      return null;
    }
  }

//---------------------------------------------------------------------------------------------------------------
}

APIvalue apiValue = APIvalue();
