import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Author.dart';
import '../model/Book.dart';

class SameAuthor extends StatefulWidget {
  Author author;
  List<Book> bookList;

  SameAuthor({super.key, required this.author, required this.bookList});

  @override
  State<StatefulWidget> createState() {
    return SameAuthorState();
  }
}

class SameAuthorState extends State<SameAuthor> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.router.push('/author', extra: widget.author);
      },
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                height: 80,
                width: 80,
                imageUrl: widget.author.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Cùng tác giả',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  widget.author.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_right_rounded,
              color: Colors.black,
              size: 50,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
            itemCount: widget.bookList.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () {
                  AppNavigation.router.push("/home/detailBook",
                      extra: widget.bookList[index]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.bookList[index]!.image!,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              height: 200,
              scrollPhysics: const BouncingScrollPhysics(),
              enableInfiniteScroll: false,
              viewportFraction: 0.4,
              padEnds: false,
              enlargeCenterPage: false,
              initialPage: _selectedIndex,
              onPageChanged: (index, reason) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )),
      ]),
    );
  }
}