import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/constant.dart';
import 'package:ebook/model/Author.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:ebook/widgets/list_book_horizontal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../model/Book.dart';
import '../utils/app_color.dart';

class AuthorView extends StatefulWidget {
  final Author author;

  const AuthorView({super.key, required this.author});

  @override
  State<StatefulWidget> createState() {
    return AuthorViewState();
  }
}

class AuthorViewState extends State<AuthorView> {
  List<String> orderList = <String>['ID', 'Tên sách', 'Đánh giá'];
  late String _selectedOrder;
  final List<Book> _bookList = <Book>[
    Book(
        name: 'Hạt giống tâm hồn',
        rating: 40,
        progress: 0,
        published_year: 2015,
        book_type: BookType.NORMAL,
        description:
            '“Hạt Giống Tâm Hồn” hẳn là không còn xa lạ với nhiều người. Tập sách này đã trở thành người bạn thân quen không thể thiếu với những người yêu sách',
        image:
            'https://thuvienhoasen.org/images/file/SFO5nWNm2ggBAmBH/hat-giong-tam-hon.png',
        src_audio:
            'https://firebasestorage.googleapis.com/v0/b/book-41cab.appspot.com/o/1-hatgiongtamhon.mp3?alt=media&token=1b664a66-38dc-4fdb-b7fd-5ff54c1fc9e4'),
    Book(
        name: 'Hạt giống tâm hồn',
        rating: 40,
        progress: 0,
        published_year: 2015,
        book_type: BookType.NORMAL,
        description:
            '“Hạt Giống Tâm Hồn” hẳn là không còn xa lạ với nhiều người. Tập sách này đã trở thành người bạn thân quen không thể thiếu với những người yêu sách',
        image:
            'https://thuvienhoasen.org/images/file/SFO5nWNm2ggBAmBH/hat-giong-tam-hon.png',
        src_audio:
            'https://firebasestorage.googleapis.com/v0/b/book-41cab.appspot.com/o/1-hatgiongtamhon.mp3?alt=media&token=1b664a66-38dc-4fdb-b7fd-5ff54c1fc9e4'),
    Book(
        name: 'Hạt giống tâm hồn',
        rating: 40,
        progress: 0,
        published_year: 2015,
        book_type: BookType.NORMAL,
        description:
            '“Hạt Giống Tâm Hồn” hẳn là không còn xa lạ với nhiều người. Tập sách này đã trở thành người bạn thân quen không thể thiếu với những người yêu sách',
        image:
            'https://thuvienhoasen.org/images/file/SFO5nWNm2ggBAmBH/hat-giong-tam-hon.png',
        src_audio:
            'https://firebasestorage.googleapis.com/v0/b/book-41cab.appspot.com/o/1-hatgiongtamhon.mp3?alt=media&token=1b664a66-38dc-4fdb-b7fd-5ff54c1fc9e4')
  ];

  @override
  void initState() {
    super.initState();
    _selectedOrder = orderList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              AppColors.blue,
              AppColors.blue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsetsDirectional.all(20),
                child: Column(children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.author.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(widget.author.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ]),
              )),
              SliverFillRemaining(
                child: Container(
                  padding: const EdgeInsetsDirectional.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      ReadMoreText(
                        widget.author.description.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                        trimMode: TrimMode.Line,
                        trimLines: 5,
                        colorClickableText: Colors.pink,
                        trimCollapsedText: 'Xem thêm',
                        trimExpandedText: 'Hiển thị ít hơn',
                        moreStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              style: Style.bold,
                              textSize: 18,
                              textColor: Colors.black,
                              text: '0 Sách Nói',
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: _selectedOrder,
                            icon: const Icon(Icons.arrow_downward),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedOrder = value!;
                              });
                            },
                            items: orderList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    )),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      ListBookHorizontal(bookList: _bookList),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
