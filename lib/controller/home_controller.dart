import 'package:ebook/repository/BookRepository.dart';
import 'package:flutter/material.dart';

import '../model/Book.dart';

class HomeController extends ChangeNotifier {
  final BookRepository _repository = BookRepository();
  List<Book>? _bigViewBooks;
  List<Book>? _normalBooks;
  List<Book>? _premiumBooks;
  List<Book>? topRatingBooks;
  bool _isLoading = false;

  List<Book>? get bigViewBooks => _bigViewBooks;

  List<Book>? get normalBooks => _normalBooks;

  List<Book>? get premiumBook => _premiumBooks;

  bool get isLoading => _isLoading;

  Future<void> firstInit(BuildContext context, int? limit, int? offset) async {
    _isLoading = true;
    notifyListeners();
    try {
      //Call api lay du lieu sach
      _bigViewBooks = await _repository.findAll(limit, offset);
      _normalBooks = await _repository.findNormalBook(10, 0);
      _premiumBooks = await _repository.findPremiumBook(10, 0);
      topRatingBooks = await _repository.findByTopRating(10, 0);

      //Cap nhat cho view
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("${e}");
    }
  }
}
