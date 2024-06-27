import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/controller/audio_controller.dart';
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../utils/audio_handler.dart';
import '../widgets/play_button.dart';
import '../widgets/seekbar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class AudioView extends StatefulWidget {
  const AudioView({super.key});

  @override
  State<StatefulWidget> createState() {
    return AudioViewState();
  }
}

class AudioViewState extends State<AudioView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      MainWrapperController controller =
          Provider.of<MainWrapperController>(context, listen: false);
      controller.updateBottomNavigationVisibility(false);
      controller.updateSongControlVisibility(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        debugPrint('Audio Pop');

        MainWrapperController mainWrapperController =
            Provider.of<MainWrapperController>(context, listen: false);
        AudioController audioController =
            Provider.of<AudioController>(context, listen: false);

        try {
          mainWrapperController.updateBottomNavigationVisibility(true);

          final processingState = audioController
              .audioPlayerHandler?.audioPlayer.playerState.processingState;
          if (processingState != ProcessingState.loading &&
              processingState != ProcessingState.buffering) {
            mainWrapperController.updateSongControlVisibility(true);
          }
          Navigator.of(context).pop();
        } catch (e) {
          debugPrint('Error from onPop AudioView:${e.toString()}');
        }
      },
      child: Consumer<AudioController>(
        builder: (context, controller, child) {
          if (controller.newAudioPlaying == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //Khởi tạo seekbar data
            Stream<SeekBarData> seekBarDataStream =
                rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
                    controller.audioPlayerHandler!.audioPlayer.positionStream,
                    controller.audioPlayerHandler!.audioPlayer.durationStream, (
              Duration position,
              Duration? duration,
            ) {
              return SeekBarData(position, duration ?? Duration.zero);
            });
            return Scaffold(
              extendBodyBehindAppBar: true,
              body: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                //393E46
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.brown, AppColors.brown2])),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                            aspectRatio: 6 / 9,
                            child: CachedNetworkImage(
                              imageUrl: controller.audioBook?.image ?? '',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      controller.audioBook?.name ?? 'Không rõ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 30,
                            )),
                        Expanded(
                          child: Text(
                            controller.audioAuthor ?? 'Không rõ',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.repeat,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<SeekBarData>(
                              stream: seekBarDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;
                                return SeekBar(
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    onChangeEnd: controller
                                        .audioPlayerHandler!.audioPlayer.seek);
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: controller.audioPlayerHandler!
                                    .audioPlayer.positionStream,
                                builder: (context, snapshot) {
                                  return IconButton(
                                      onPressed: () {
                                        controller
                                            .audioPlayerHandler!.audioPlayer
                                            .seek(Duration(
                                                seconds: controller
                                                        .audioPlayerHandler!
                                                        .audioPlayer
                                                        .position
                                                        .inSeconds -
                                                    10));
                                      },
                                      icon: const Icon(
                                        Icons.replay_10_outlined,
                                        color: Colors.white,
                                        size: 50,
                                      ));
                                },
                              ),
                              PlayButton(
                                  audioPlayer: controller
                                      .audioPlayerHandler!.audioPlayer),
                              StreamBuilder(
                                stream: controller.audioPlayerHandler!
                                    .audioPlayer.positionStream,
                                builder: (context, snapshot) {
                                  return IconButton(
                                      onPressed: () {
                                        controller
                                            .audioPlayerHandler!.audioPlayer
                                            .seek(Duration(
                                                seconds: controller
                                                        .audioPlayerHandler!
                                                        .audioPlayer
                                                        .position
                                                        .inSeconds +
                                                    10));
                                      },
                                      icon: const Icon(
                                        Icons.forward_10_outlined,
                                        color: Colors.white,
                                        size: 50,
                                      ));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800
            ])),
      ),
    );
  }
}
