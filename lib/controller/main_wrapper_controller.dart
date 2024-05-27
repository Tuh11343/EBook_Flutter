import 'package:ebook/repository/AuthorRepository.dart';
import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:flutter/material.dart';

import '../model/Author.dart';
import '../model/Book.dart';
import '../model/genre.dart';

class MainWrapperController extends ChangeNotifier {

  bool showSongControl=false;

  void updateShowSongControl(bool show){
    showSongControl=show;
    notifyListeners();
  }

}
