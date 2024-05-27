import 'package:ebook/constant.dart';
import 'package:ebook/controller/audio_controller.dart';
import 'package:ebook/controller/detail_book_controller.dart';
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:ebook/views/author_view.dart';
import 'package:ebook/views/detail_book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../controller/HomeAuthorController.dart';
import '../controller/home_controller.dart';
import '../model/Author.dart';
import '../model/Book.dart';
import '../utils/app_navigation.dart';
import 'audio_view.dart';
import 'home_view.dart';

class MainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

/*class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Book book = Book(
        id: 1,
        book_type: BookType.NORMAL,
        published_year: 2014,
        rating: 10,
        name: "Nuôi Con Bằng Trái Tim Tỉnh Thức",
        progress: 0,
        image: "",
        lyric: null,
        src_audio: "",
        language: "VNI",
        description:
            "Tôi từng đọc đâu đó rằng từ khi có con, trái tim chúng ta nhảy ra khỏi lồng ngực và bắt đầu đi loanh quanh trên đôi chan của chúng nó mãi mãi. Nỗi đau, cái đẹp, sự bất lực và sự tuyệt vời");

    Author author=Author(id: 1,image: 'https://file.hstatic.net/200000504927/file/robin-sharma-1_2ac7294470b14e388955d6c5b63556af_grande.png',name: 'Jason Medelson',description:'Tôi từng đọc đâu đó rằng từ khi có con, trái tim chúng ta nhảy ra khỏi lồng ngực và bắt đầu đi loanh quanh trên đôi chan của chúng nó mãi mãi. Nỗi đau, cái đẹp, sự bất lực và sự tuyệt vời');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateNotifier()),
        ChangeNotifierProvider(create: (context) => HomeAuthorController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => AudioController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            return SafeArea(
              top: true,
              bottom: true,
              child: AuthorView(author: author),
              // child: DetailBookView(book: book),
              // child: Scaffold(
              //   bottomNavigationBar: SlidingClippedNavBar(
              //     backgroundColor: Colors.white,
              //     onButtonPressed: (index) {
              //       setState(() {
              //         selectedIndex = index;
              //         if (index == 0) {
              //           Provider.of<AppStateNotifier>(context, listen: false)
              //               .resetState(AppState.home);
              //         } else if (index == 1) {
              //           Provider.of<AudioController>(context,listen:false).newAudioPlaying=true;
              //           Provider.of<AppStateNotifier>(context, listen: false)
              //               .resetState(AppState.audio);
              //         }
              //       });
              //     },
              //     iconSize: 20,
              //     activeColor: Colors.black,
              //     selectedIndex: selectedIndex,
              //     barItems: [
              //       BarItem(
              //         title: 'Home',
              //         icon: Icons.home_rounded,
              //       ),
              //       BarItem(
              //         title: 'Search',
              //         icon: Icons.search_rounded,
              //       ),
              //     ],
              //   ),
              //   body: Consumer<AppStateNotifier>(
              //     builder: (context, appState, child) {
              //       switch (appState.currentState) {
              //         case AppState.home:
              //           return HomeView();
              //         case AppState.audio:
              //           return AudioView();
              //         case AppState.detailBook:
              //           return AudioView();
              //         default:
              //           return HomeView();
              //       }
              //     },
              //   ),
              // ),
            );
          },
        ),
      ),
    );
  }
}*/

class MainWrapperState extends State<MainWrapper> {
  int _selectedPage = 0;

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          bottomNavigationBar: SlidingClippedNavBar(
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
            ],
          ),
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => MainWrapperController()),
              ChangeNotifierProvider(
                  create: (context) => HomeAuthorController()),
              ChangeNotifierProvider(create: (context) => HomeController()),
              ChangeNotifierProvider(create: (context) => AudioController()),
              ChangeNotifierProvider(
                  create: (context) => DetailBookController()),
            ],
            child: Consumer<MainWrapperController>(
              builder: (context, controller, child) {
                return Stack(children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.navigationShell,
                  ),
                  if (controller.showSongControl)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: getScreenWidth(),
                        height: 100,
                        color: Colors.red,
                        child: Row(
                          children: [
                            SongControl(audioController: Provider.of<AudioController>(context,listen: false))
                          ],
                        ),
                      ),
                    ),
                ]);
              },
            ),
          )),
    );
  }
}


class SongControl extends StatelessWidget{

  AudioController audioController;

  SongControl({required this.audioController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioController.audioPlayerHandler!.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final playerState = snapshot.data;
          final processingState =
              (playerState as PlayerState)!.processingState;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return const SizedBox(
              width: 75.0,
              height: 75.0,
              child: CircularProgressIndicator(),
            );
          } else if (!audioController.audioPlayerHandler!.audioPlayer.playing) {
            return IconButton(
                onPressed: () {
                  audioController.audioPlayerHandler!.audioPlayer.play();
                },
                iconSize: 75,
                icon: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ));
          } else if (processingState !=
              ProcessingState.completed) {
            return IconButton(
                onPressed: () {
                  audioController.audioPlayerHandler!.audioPlayer.pause();
                },
                iconSize: 75,
                icon: const Icon(
                  Icons.pause_circle,
                  color: Colors.white,
                ));
          } else {
            return IconButton(
                onPressed: () {
                  audioController.audioPlayerHandler!.audioPlayer.seek(Duration.zero);
                },
                iconSize: 75,
                icon: const Icon(
                  Icons.replay_circle_filled_outlined,
                  color: Colors.white,
                ));
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

}
