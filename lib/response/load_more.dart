import '../model/Book.dart';

class LoadMoreResponse{
  List<Book> bookList;
  int maxLength;

  LoadMoreResponse({required this.bookList,required this.maxLength});
}