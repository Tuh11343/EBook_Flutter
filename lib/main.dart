import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/controller/HomeAuthorController.dart';
import 'package:ebook/firebase_options.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EBook',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}

class HomeAuthorView extends StatefulWidget {
  const HomeAuthorView({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeAuthorViewState();
  }
}

class HomeAuthorViewState extends State<HomeAuthorView> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<HomeAuthorController>(context, listen: false)
          .findAll(context, null, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeAuthorController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(), // Hiển thị loading
          );
        } else if (controller.authors == null || controller.authors!.isEmpty) {
          return const Center(
            child: Text('No authors found.'),
          );
        } else {
          return CarouselSlider.builder(
            itemCount: controller.authors!.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl: controller.authors![index].image,
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
                        text: controller.authors![index].name,
                      )
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              padEnds: false,
              height: 250,
              initialPage: _activeIndex,
              enlargeCenterPage: false,
              viewportFraction: 0.4,
              enableInfiniteScroll: false,
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
