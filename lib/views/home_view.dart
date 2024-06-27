import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import '../utils/app_color.dart';
import '../widgets/widgets.dart';

class HomeView extends StatefulWidget {
  final Function(int) onBottomNavBarButtonPressed;
  const HomeView({super.key,required this.onBottomNavBarButtonPressed});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false)
          .firstInit(context, 10, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          bool willExit = await showExitConfirmationDialog(context);
          if (willExit) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('EBook'),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    widget.onBottomNavBarButtonPressed(1);
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  )),
            ],
          ),
          body: Container(
            color: AppColors.gray,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const BigBookWidget(),
                  Consumer<HomeController>(
                      builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.normalBooks == null ||
                        controller.normalBooks!.isEmpty) {
                      return const Center(
                        child: Text('Không tìm thấy sách'),
                      );
                    } else {
                      return NormalHorizontalBook(
                          title: 'Sách miễn phí',
                          bookList: controller.normalBooks!);
                    }
                  }),
                  Consumer<HomeController>(
                      builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.premiumBook == null ||
                        controller.premiumBook!.isEmpty) {
                      return const Center(
                        child: Text('No normal books found'),
                      );
                    } else {
                      return NormalHorizontalBook(
                          title: 'Sách giới hạn',
                          bookList: controller.premiumBook!);
                    }
                  }),
                  Consumer<HomeController>(
                      builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.topRatingBooks == null ||
                        controller.topRatingBooks!.isEmpty) {
                      return const Center(
                        child: Text('No normal books found'),
                      );
                    } else {
                      return NormalHorizontalBook(
                          title: 'Sách được đánh giá cao',
                          bookList: controller.topRatingBooks!);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
