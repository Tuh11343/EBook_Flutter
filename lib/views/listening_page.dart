

import 'package:ebook/views/lyric_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'audio_view.dart';

class ListeningPage extends StatefulWidget{
  const ListeningPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListeningPageState();
  }

}

class ListeningPageState extends State<ListeningPage> with TickerProviderStateMixin{

  late PageController _pageViewController;
  // late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    // _tabController = TabController(length: 3,vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    // _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageViewController,
      onPageChanged: _handlePageViewChanged,
      children:const [
        AudioView(),
        LyricView(),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    // if (!_isOnDesktopAndWeb) {
    //   return;
    // }
    // _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    // _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // bool get _isOnDesktopAndWeb {
  //   if (kIsWeb) {
  //     return true;
  //   }
  //   switch (defaultTargetPlatform) {
  //     case TargetPlatform.macOS:
  //     case TargetPlatform.linux:
  //     case TargetPlatform.windows:
  //       return true;
  //     case TargetPlatform.android:
  //     case TargetPlatform.iOS:
  //     case TargetPlatform.fuchsia:
  //       return false;
  //   }
  // }

}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}