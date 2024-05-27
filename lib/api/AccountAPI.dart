import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/Account.dart';
import '../utils/APIProvider.dart';

class AccountAPI {
  Future<Response> findByID(int id) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/account/id", queryParameters: {"id": id});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to find by id: $e');
    }
  }

  Future<Response> findByEmail(String email) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/account/email", queryParameters: {"email": email});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to find by email: $e');
    }
  }

  Future<Response> signIn(String email, String password) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/account/signIn",
          queryParameters: {"email": email, "password": password});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<Response> createAccount(Account account) async{
    try{
      Response response = await ApiProvider.getInstance().post("/api/v1/account",data: account);
      return response;
    }on DioException catch(e){
      throw Exception('Failed to create account: $e');
    }
  }

}
