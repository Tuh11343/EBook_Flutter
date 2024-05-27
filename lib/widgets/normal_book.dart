import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class NormalHorizontalBook extends StatefulWidget {
  const NormalHorizontalBook({super.key});

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
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.normalBooks == null ||
            controller.normalBooks!.isEmpty) {
          return const Center(
            child: Text('No normal books found'),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const CustomText(text: 'Sách miễn phí', textSize: 18, style: Style.bold, textColor: Colors.black),
                const SizedBox(height: 20,),
                CarouselSlider.builder(
                  itemCount: controller.normalBooks!.length,
                  itemBuilder: (context, index, realIndex) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.normalBooks![index].image ?? "",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              textSize: 16,
                              style: Style.normal,
                              textColor: Colors.black,
                              text: controller.normalBooks![index].name,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 160,
                    initialPage: _activeIndex,
                    enlargeCenterPage: false,
                    viewportFraction: 0.4,
                    enableInfiniteScroll: true,
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
      },
    );
  }
}
