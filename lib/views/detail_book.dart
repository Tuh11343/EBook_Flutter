import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/controller/detail_book_controller.dart';
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../controller/audio_controller.dart';
import '../model/Author.dart';
import '../model/Book.dart';

class DetailBookView extends StatefulWidget {
  Book book;

  DetailBookView({super.key, required this.book});

  @override
  State<StatefulWidget> createState() {
    return DetailBookViewState();
  }
}

class DetailBookViewState extends State<DetailBookView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<DetailBookController>(context, listen: false)
          .init(widget.book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailBookController>(
      builder: (context, controller, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            controller.backPressEvent();
            Navigator.of(context).pop();
          },
          child: Scaffold(
            extendBodyBehindAppBar: false,
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [AppColors.blue, Colors.blueGrey.withOpacity(1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.all(20),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 25,
                                )),
                          ],
                        ),
                      ),
                      FirstPart(
                        widget: widget,
                        controller: controller,
                      ),
                      SecondPart(
                        widget: widget,
                        controller: controller,
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

class FirstPart extends StatelessWidget {
  const FirstPart({
    super.key,
    required this.widget,
    required this.controller,
  });

  final DetailBookView widget;
  final DetailBookController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return CircularProgressIndicator();
    } else if (controller.authorList.isEmpty) {
      return Text('Khong co du lieu tac gia');
    } else {
      return Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.book.image!,
                  height: 300,
                  width: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.book.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                context.push('/home/detailBook/author',
                    extra: controller.authorList.last![0]);
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomText(
                    text: controller.authorList.last![0].name,
                    textSize: 16,
                    style: Style.normal,
                    textColor: Colors.white),
                const Icon(Icons.arrow_right_sharp,
                    size: 25, color: Colors.white),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 25, color: Colors.white),
                const SizedBox(width: 5),
                CustomText(
                    text: widget.book.rating.toString(),
                    textSize: 16,
                    style: Style.normal,
                    textColor: Colors.white),
                const SizedBox(width: 5),
                const CustomText(
                    text: "(1 đánh giá)",
                    textSize: 16,
                    style: Style.normal,
                    textColor: Colors.white),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (1 == 2)
                  IconButton(
                      onPressed: () {
                        //Them vao yeu thich
                      },
                      icon: const Icon(
                        Icons.favorite_sharp,
                        color: Colors.white,
                        size: 25,
                      ))
                else
                  IconButton(
                      onPressed: () {
                        //Bo yeu thich
                      },
                      icon: const Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.white,
                        size: 25,
                      )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.gray80,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //Di den audio view

                        AudioController audioController =
                            Provider.of<AudioController>(context,
                                listen: false);
                        audioController.setAudioContent(
                            widget.book.name,
                            controller.authorList.last![0].name,
                            widget.book.image);
                        audioController.resetAudio(widget.book.src_audio!);
                        context.push('/home/detailBook/audio');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              text: "Tiến Hành Nghe",
                              textSize: 16,
                              style: Style.bold,
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}

class SecondPart extends StatelessWidget {
  const SecondPart({
    super.key,
    required this.widget,
    required this.controller,
  });

  final DetailBookView widget;
  final DetailBookController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Giới thiệu nội dung",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ReadMoreText(
                  widget.book.description.toString(),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: controller.genreList.isNotEmpty &&
                          controller.genreList.last != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                                controller.genreList.last!.length, (index) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.gray80,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  controller.genreList.last![index].name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                              );
                            }),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(height: 10, color: Colors.black, thickness: 0.5),
                ThirdPart(
                  widget: widget,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ThirdPart extends StatelessWidget {
  final DetailBookView widget;
  final DetailBookController controller;

  const ThirdPart({super.key, required this.widget, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return CircularProgressIndicator();
    } else if (controller.authorBookList.isEmpty) {
      return Text('Khong co du lieu');
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tương tự với sách này',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SameAuthor(
              author: controller.authorList[0].last,
              bookList: controller.authorBookList[0].last!),
        ],
      );
    }
  }
}

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
        context.push('/home/detailBook/author', extra: widget.author);
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
                  context.push("/home/detailBook",
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
