import 'package:ebook/repository/AuthorRepository.dart';
import 'package:flutter/material.dart';

import '../model/Author.dart';

class HomeAuthorController extends ChangeNotifier {
  final AuthorRepository _repository = AuthorRepository();
  List<Author>? _authors;
  bool _isLoading = false;

  List<Author>? get authors => _authors;

  bool get isLoading => _isLoading;

  Future<void> findAll(BuildContext context, int? limit, int? offset) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authors = await _repository.findAll(limit, offset);
      if (authors != null) {
        _isLoading = false;
        _authors = authors;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
