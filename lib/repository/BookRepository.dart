import 'package:ebook/model/Book.dart';
import 'package:flutter/cupertino.dart';

import '../api/BookAPI.dart';


class BookRepository{

  final BookAPI apiService = BookAPI();

  Future<List<Book>> findAll(int? limit,int? offset) async {
    final response = await apiService.findAll(limit,offset);
    List<dynamic> data = response.data['books'];
    List<Book> books = data.map((json) => Book.fromJson(json)).toList();
    return books;
  }

  Future<List<Book>> findNormalBook(int? limit,int? offset) async {
    final response = await apiService.findNormal(limit, offset);
    List<dynamic> data = response.data['books'];
    List<Book> books = data.map((json) => Book.fromJson(json)).toList();
    return books;
  }

  Future<List<Book>?> findPremiumBook(int? limit,int? offset) async {
    final response = await apiService.findPremium(limit, offset);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return null;
  }

  Future<List<Book>> findByAuthorID(int authorID,int? limit,int? offset) async {
    final response = await apiService.findByAuthorID(authorID, limit, offset);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return List.empty();
  }

  Future<List<Book>?> findByFavorite(int id) async {
    final response = await apiService.findByFavorite(id);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return null;
  }

  Future<List<Book>?> findByNameAndGenre(String name,int genreID,int? limit,int? offset) async {
    final response = await apiService.findByNameAndGenre(name, genreID, limit, offset);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return null;
  }

  Future<List<Book>?> findByName(String name,int? limit,int? offset) async {
    final response = await apiService.findByName(name, limit, offset);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return null;
  }

  Future<List<Book>?> findByTopRating(int? limit,int? offset) async {
    final response = await apiService.findByTopRating(limit, offset);
    if(response.data['books']!=null){
      List<dynamic> data = response.data['books'];
      List<Book> books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return null;
  }

}