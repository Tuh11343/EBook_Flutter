import 'package:ebook/constant.dart';
import 'package:ebook/controller/audio_controller.dart';
import 'package:ebook/controller/detail_book_controller.dart';
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:ebook/controller/payment_controller.dart';
import 'package:ebook/views/author_view.dart';
import 'package:ebook/views/detail_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../app_instance.dart';
import '../controller/HomeAuthorController.dart';
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';
import '../model/Author.dart';
import '../model/Book.dart';
import '../utils/app_navigation.dart';
import '../widgets/song_control.dart';
import 'audio_view.dart';
import 'home_view.dart';

class MainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  int _selectedPage = 0;

  void onBottomNavBarButtonPressed(int index) {
    setState(() {
      _selectedPage = index;
    });
    _goToBranch(index);
  }

  void _goToBranch(int index) async {
    if (index == 3) {
      var mainWrapperController =
          Provider.of<MainWrapperController>(context, listen: false);
      if (mainWrapperController.accountLoading) {
        messageSnackBar(context, 'Đang load tài khoản');
      } else {
        var mainWrapperController =
            Provider.of<MainWrapperController>(context, listen: false);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        int accountID = prefs.getInt(AppInstance().accountID) ?? -1;
        if (accountID == -1) {
        } else {
          await mainWrapperController.findAccountByID(accountID);
        }
        if (mainWrapperController.currentAccount != null) {
          widget.navigationShell.goBranch(4,
              initialLocation: 4 == widget.navigationShell.currentIndex);
        } else {
          widget.navigationShell.goBranch(index,
              initialLocation: index == widget.navigationShell.currentIndex);
        }
      }
    } else {
      widget.navigationShell.goBranch(index,
          initialLocation: index == widget.navigationShell.currentIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var mainWrapperController =
          Provider.of<MainWrapperController>(context, listen: false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int accountID = prefs.getInt(AppInstance().accountID) ?? -1;
      if (accountID == -1) {
      } else {
        await mainWrapperController.findAccountByID(accountID);

        //Check if subscriptionHistory premium expired
        if (mainWrapperController.currentAccountSubscription?.bookType ==
            BookType.PREMIUM) {
          var subscriptionHistory =
              mainWrapperController.accountSubscriptionHistory;
          if (subscriptionHistory != null) {
            if (subscriptionHistory.end!.isBefore(DateTime.now())) {
              //Update subscription to normal
              var paymentController =
                  Provider.of<PaymentController>(context, listen: false);
              var result = await paymentController.updateAccountToNormal(
                  mainWrapperController.currentAccountSubscription!,
                  mainWrapperController.accountSubscriptionHistory!);
              if(result){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gói hội viên của bạn đã hết hạn'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Có lỗi xảy ra trong quá trình hạ gói'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          }
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomNavigationBar:
            Provider.of<MainWrapperController>(context, listen: true)
                    .bottomNavigationVisibility
                ? SlidingClippedNavBar(
                    backgroundColor: Colors.white,
                    onButtonPressed: (index) {
                      setState(() {
                        _selectedPage = index;
                      });
                      _goToBranch(index);
                    },
                    iconSize: 20,
                    activeColor: Colors.black,
                    selectedIndex: _selectedPage,
                    barItems: [
                      BarItem(
                        title: 'Home',
                        icon: Icons.home_rounded,
                      ),
                      BarItem(
                        title: 'Search',
                        icon: Icons.search_rounded,
                      ),
                      BarItem(
                        title: 'Favorite',
                        icon: Icons.local_library_rounded,
                      ),
                      BarItem(
                        title: 'User',
                        icon: Icons.person,
                      ),
                    ],
                  )
                : null,
        body: Stack(children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.navigationShell,
          ),
          if (Provider.of<MainWrapperController>(context, listen: true)
              .songControlVisibility)...[
            const Positioned(
              bottom: 0,
              child: SongControl(),
            ),
          ]
        ]),
      ),
    );
  }
}


