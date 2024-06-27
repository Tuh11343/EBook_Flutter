import 'dart:async';

import 'package:ebook/constant.dart';
import 'package:ebook/controller/audio_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../model/lyric.dart';
import '../utils/app_color.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricView extends StatefulWidget {
  const LyricView({super.key});

  @override
  State<StatefulWidget> createState() {
    return LyricViewState();
  }
}

class LyricViewState extends State<LyricView> {
  List<Lyric> lyricsList = [];
  String totalLyric = '';
  String currentLyric = '';
  int currentLine = -1;
  late Timer timer;
  int startLyricIndex = -1;
  final ScrollController _scrollController = ScrollController();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  void loadLyric(String? lyric) {
    String lyricsString = lyric ?? '';
    if (lyricsString.isNotEmpty) {
      List<String> lines = lyricsString.split('\n');
      for (String line in lines) {
        if (line.contains('[') && line.contains(']')) {
          String timeString =
              line.substring(line.indexOf('[') + 1, line.indexOf(']'));
          String text = line.substring(line.indexOf(']') + 1).trim();
          int time = parseTimeToMillis(timeString);

          lyricsList.add(Lyric(time: time, lyric: text));
          totalLyric += '$text\n';
        }
      }
    }
  }

  int parseTimeToMillis(String time) {
    int minutes = int.parse(time.substring(0, 2));
    int seconds = int.parse(time.substring(3, 5));
    int millis = int.parse(time.substring(6, 8)) * 10;
    return (minutes * 60 + seconds) * 1000 + millis;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      loadLyric(Provider.of<AudioController>(context, listen: false)
          .audioBook
          ?.lyric);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.white80,
          width: double.infinity,
          child: Consumer<AudioController>(
            builder: (context, controller, child) {
              if (controller.newAudioPlaying == true) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return StreamBuilder(
                  stream: controller
                      .audioPlayerHandler?.audioPlayer?.playerStateStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (lyricsList.isNotEmpty) {
                      if (snapshot.hasData) {
                        final playerState = snapshot.data;
                        final processingState =
                            (playerState as PlayerState)!.processingState;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          //Nếu đang load thì không làm gì
                        } else if (controller
                            .audioPlayerHandler!.audioPlayer.playing) {
                          //Nếu nhạc đang chơi thì update lyric
                          updateCurrentLyricIndex(controller);
                        } else if (processingState ==
                            ProcessingState.completed) {
                          //Nếu bài nhạc kết thúc thì dừng thằng lyric lại
                          debugPrint('Ket thuc bai dung lyric');
                          setState(() {
                            startLyricIndex = -1;
                            timer.cancel();
                          });
                        } else {
                          debugPrint('Khong ro');
                        }
                      } else {}
                    }
                    /*return SingleChildScrollView(
                      controller: _scrollController,
                      child: RichText(
                        text: TextSpan(
                          children: highlightCurrentLyric(
                              totalLyric, currentLyric),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    );*/
                    return ScrollablePositionedList.builder(
                      itemCount: lyricsList.length,
                      itemBuilder: (context, index) {
                        if (currentLine == index) {
                          return RichText(text: test(lyricsList[index].lyric));
                        }
                        return Text(lyricsList[index].lyric);
                      },
                      itemScrollController: itemScrollController,
                      scrollOffsetController: scrollOffsetController,
                      itemPositionsListener: itemPositionsListener,
                      scrollOffsetListener: scrollOffsetListener,
                      initialAlignment: 0.5,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void updateCurrentLyricIndex(AudioController audioController) {
    try {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        startLyricIndex = 0;
        var position = audioController
            .audioPlayerHandler!.audioPlayer.position.inMilliseconds;
        for (int i = 0; i < lyricsList.length - 1; i++) {
          var currentLyricTime = lyricsList[i].time;

          //Nếu là dòng lyric cuối
          if (i == lyricsList.length - 1) {
            if (position >= currentLyricTime) {
              if (currentLyric != lyricsList[i].lyric) {
                setState(() {
                  currentLyric = lyricsList[i].lyric;
                  currentLine = i;
                  /*itemScrollController.scrollTo(
                      index: currentLine,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutCubic);*/
                });
              }
              break;
            }
          } else {
            var nextCurrentLyricTime = lyricsList[i + 1].time;

            if (position >= currentLyricTime &&
                position < nextCurrentLyricTime) {
              if (currentLyric != lyricsList[i].lyric) {
                setState(() {
                  currentLyric = lyricsList[i].lyric;
                  currentLine = i;
                  /*itemScrollController.scrollTo(
                      index: currentLine,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutCubic,);*/
                  itemScrollController.jumpTo(index: currentLine);
                });
              }
              break;
            }
          }

          //Cong lyric length de tim kiem index cua current lyric neu co
          startLyricIndex += lyricsList[i].lyric.length + 1;
        }
      });
    } catch (e) {
      debugPrint('Error from updateCurrentLyricIndex:${e}');
    }
  }

  List<TextSpan> highlightCurrentLyric(String totalLyric, String currentLyric) {
    List<TextSpan> spans = [];
    int currentLyricIndex = startLyricIndex;

    debugPrint('Current Lyric Index:${currentLyricIndex}');

    // Nếu currentLyric rỗng, thêm toàn bộ totalLyric vào spans và trả về
    if (currentLyric.isEmpty) {
      spans.add(TextSpan(text: totalLyric));
      return spans;
    }

    // Nếu không tìm thấy currentLyric, thêm phần còn lại của totalLyric vào spans
    if (currentLyricIndex == -1) {
      spans.add(TextSpan(text: totalLyric));
    }

    // Nếu có văn bản trước currentLyric, thêm nó vào spans
    if (currentLyricIndex > 0) {
      spans.add(TextSpan(text: totalLyric.substring(0, currentLyricIndex)));
    }

    // Thêm currentLyric vào spans với màu đỏ
    spans.add(TextSpan(
        text: currentLyric,
        style: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.normal, fontSize: 16)));

    currentLyricIndex += currentLyric.length;
    spans.add(TextSpan(
        text: totalLyric.substring(currentLyricIndex, totalLyric.length)));

    return spans;
  }

  TextSpan test(String lyric) {
    return TextSpan(
        text: lyric,
        style: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.normal, fontSize: 16));
  }

  double getAlignment({
    required int index,
    required double viewPortHeight,

    required double itemHeight,

    double alignmentOnItem = 0.5,
  }) {
    assert(alignmentOnItem >= 0 && alignmentOnItem <= 1);
    final relativePageHeight = 1 / viewPortHeight * itemHeight;
    return 0.5 - relativePageHeight * alignmentOnItem;
  }
}
