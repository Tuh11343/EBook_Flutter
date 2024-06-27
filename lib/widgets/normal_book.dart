import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/controller/home_controller.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Book.dart';
import 'widgets.dart';

class NormalHorizontalBook extends StatefulWidget {

  String title;
  List<Book> bookList;

  NormalHorizontalBook({super.key,required this.title,required this.bookList});

  @override
  State<StatefulWidget> createState() {
    return NormalHorizontalBookState();
  }
}

class NormalHorizontalBookState extends State<NormalHorizontalBook> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            if(widget.title.isNotEmpty)...[
              CustomText(text: widget.title, textSize: 18, style: Style.bold, textColor: Colors.black),
              const SizedBox(height: 20,),
            ],
            CarouselSlider.builder(
              itemCount: widget.bookList.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () {
                    AppNavigation.router.push('/detailBook',extra: widget.bookList[index]);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.bookList[index].image ?? "",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: 200,
                initialPage: _activeIndex,
                viewportFraction: 0.4,
                enableInfiniteScroll: false,
                padEnds: false,
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    _activeIndex = index;
                  });
                },
              ),
            ),
          ]
      ),
    );
  }
}
