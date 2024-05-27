
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../model/Book.dart';

class ListBookHorizontal extends StatefulWidget{

  List<Book> bookList;

  ListBookHorizontal({super.key, required this.bookList});

  @override
  State<StatefulWidget> createState() {
    return ListBookHorizontalState();
  }

}

class ListBookHorizontalState extends State<ListBookHorizontal>{

  int _selectedBookIndex=0;


  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(itemCount: widget.bookList.length, itemBuilder: (context, index, realIndex) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: CachedNetworkImage(
          imageUrl: widget.bookList[index].image!,
          fit: BoxFit.cover,
        ),
      );
    }, options: CarouselOptions(
      initialPage: _selectedBookIndex,
      onPageChanged: (index, reason) {
        setState(() {
          _selectedBookIndex=index;
        });
      },
      enlargeCenterPage: false,
      viewportFraction: 0.4,
      height: 200,
      enableInfiniteScroll: false,
      padEnds: false,
      scrollPhysics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,

    ));
  }

}