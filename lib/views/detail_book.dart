import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/controller/detail_book_controller.dart';
import 'package:ebook/controller/detail_book_controller_2.dart';
import 'package:ebook/controller/favoriteController.dart';
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_instance.dart';
import '../constant.dart';
import '../controller/audio_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../model/Book.dart';
import '../widgets/same_author.dart';

class DetailBookView extends StatefulWidget {
  Book book;

  DetailBookView({super.key, required this.book});

  @override
  State<StatefulWidget> createState() {
    return DetailBookViewState();
  }
}

class DetailBookViewState extends State<DetailBookView> {
  int? _userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      //Get account and other information
      var mainWrapperController =
          Provider.of<MainWrapperController>(context, listen: false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int accountID = prefs.getInt(AppInstance().accountID) ?? -1;
      if (accountID == -1) {
        messageSnackBar(context, 'Có lỗi xảy ra khi tìm kiếm tài khoản');
        return;
      }
      await mainWrapperController.findAccountByID(accountID);
      _userID = mainWrapperController.currentUser!.id!;

      var detailBookController =
          Provider.of<DetailBookController2>(context, listen: false);
      detailBookController.init(_userID ?? -1, widget.book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller:
                      Provider.of<DetailBookController2>(context, listen: true),
                  userID: _userID,
                ),
                SecondPart(
                  widget: widget,
                  controller: Provider.of<DetailBookController2>(context,listen: true),
                ),
              ],
            )),
      ),
    );
  }
}

class FirstPart extends StatelessWidget {
  const FirstPart({
    super.key,
    required this.widget,
    required this.controller,
    this.userID,
  });

  final DetailBookView widget;
  final DetailBookController2 controller;
  final int? userID;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const CircularProgressIndicator();
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
            //Kiểm tra xem danh sách tác giả có trống không hiển thị
            if(controller.authorList.isNotEmpty)...[
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/author', extra: controller.authorList[0]);
                    },
                    child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CustomText(
                          text: controller.authorList[0].name,
                          textSize: 16,
                          style: Style.normal,
                          textColor: Colors.white),
                      const Icon(Icons.arrow_right_sharp,
                          size: 25, color: Colors.white),
                    ]),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ],

            //Phần này hiển thị rating
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

            //Phần này xử lý nhấn chọn yêu thích
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!controller.isFavorite)
                  IconButton(
                      onPressed: () async {
                        try {
                          if (userID != null) {
                            var result = await controller.favoriteClick(
                                userID!, widget.book.id!);
                            if (result) {
                              messageSnackBar(context,
                                  'Thêm vào danh sách yêu thích thành công');

                              //Call Api to update favorite list
                              Provider.of<FavoriteController>(context,
                                      listen: false)
                                  .favoriteListChanged(userID!, 5, 0);
                            } else {
                              messageSnackBar(context, 'Có lỗi xảy ra');
                            }
                          }
                        } catch (e) {
                          debugPrint(
                              'Error from view detail book favorite click:${e}');
                          messageSnackBar(context, 'Có lỗi xảy ra');
                        }
                      },
                      icon: const Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.white,
                        size: 25,
                      ))
                else
                  IconButton(
                      onPressed: () async {
                        //Unfavorite
                        try {
                          if (userID != null) {
                            var result = await controller.favoriteClick(
                                userID!, widget.book.id!);
                            if (result) {
                              messageSnackBar(context,
                                  'Loại khỏi danh sách yêu thích thành công');

                              //Call Api to update favorite list
                              Provider.of<FavoriteController>(context,
                                      listen: false)
                                  .favoriteListChanged(userID!, 5, 0);
                            } else {
                              messageSnackBar(context, 'Có lỗi xảy ra');
                            }
                          }
                        } catch (e) {
                          debugPrint(
                              'Error from view detail book favorite click:${e}');
                          messageSnackBar(context, 'Có lỗi xảy ra');
                        }
                      },
                      icon: const Icon(
                        Icons.favorite_sharp,
                        color: Colors.white,
                        size: 25,
                      )),

                //Phần này xử lý nghe nhạc
                Expanded(
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.gray80,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //Đi đến audio view

                        AudioController audioController =
                            Provider.of<AudioController>(context,
                                listen: false);
                        audioController.setAudioContent(
                          widget.book,
                          controller.authorList.isNotEmpty
                              ? controller.authorList[0].name
                              : 'Không rõ',
                        );
                        audioController.resetAudio(widget.book.src_audio!);
                        context.push('/songControl');
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
  final DetailBookController2 controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const CircularProgressIndicator();
    } else {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Giới thiệu nội dung",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ReadMoreText(
                    widget.book.description?.toString() ??
                        'Không có thông tin chi tiết',
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(controller.genreList.length, (index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.gray80,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.genreList[index].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        );
                      }),
                    ),
                  ),
                  // : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                      height: 10, color: Colors.black, thickness: 0.5),
                  if (controller.authorList.isNotEmpty) ...[
                    ThirdPart(
                      widget: widget,
                      controller: controller,
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}

class ThirdPart extends StatelessWidget {
  final DetailBookView widget;
  final DetailBookController2 controller;

  const ThirdPart({super.key, required this.widget, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const CircularProgressIndicator();
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
              author: controller.authorList[0],
              bookList: controller.authorBookList[0]),
        ],
      );
    }
  }
}
