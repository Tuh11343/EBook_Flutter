import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import 'custom_text.dart';

class BigBookWidget extends StatefulWidget {
  const BigBookWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BigBookWidgetState();
  }
}

class _BigBookWidgetState extends State<BigBookWidget> {
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
            child: CircularProgressIndicator(), // Hiển thị loading
          );
        } else if (controller.bigViewBooks == null || controller.bigViewBooks!.isEmpty) {
          return const Center(
            child: Text('No bigViewBooks found'),
          );
        } else {
          return CarouselSlider.builder(
            itemCount: controller.bigViewBooks!.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () {
                  context.push("/home/detailBook",extra: controller.bigViewBooks![index]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: controller.bigViewBooks![index].image ?? "",
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
                        text: controller.bigViewBooks![index].name,
                      )
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 270,
              initialPage: _activeIndex,
              enlargeCenterPage: true,
              viewportFraction: 0.5,
              enableInfiniteScroll: true,
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _activeIndex = index;
                });
              },
            ),
          );
        }
      },
    );
  }
}