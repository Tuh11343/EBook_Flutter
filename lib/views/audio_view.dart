import 'package:ebook/controller/audio_controller.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioController>(
      builder: (context, value, child) {

        //Khoi tao seekBarData
        Stream<SeekBarData> seekBarDataStream =
            rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
                value.audioPlayerHandler!.audioPlayer.positionStream,
                value.audioPlayerHandler!.audioPlayer.durationStream, (
          Duration position,
          Duration? duration,
        ) {
          return SeekBarData(position, duration ?? Duration.zero);
        });

        if (value.newAudioPlaying == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/song.jpg',
                    fit: BoxFit.cover,
                  ),
                  const _BackgroundFilter(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {

                              },
                              icon: const Icon(
                                Icons.arrow_circle_down,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const Spacer(),
                            FilledButton.tonal(
                              onPressed: () {

                              },
                              child: const CustomText(
                                text: 'Mua ngay',
                                textColor: Colors.white,
                                style: Style.bold,
                                textSize: 16,
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<SeekBarData>(
                                stream: seekBarDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  return SeekBar(
                                      position: positionData?.position ??
                                          Duration.zero,
                                      duration: positionData?.duration ??
                                          Duration.zero,
                                      onChangeEnd: value.audioPlayerHandler!
                                          .audioPlayer.seek);
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder(
                                  stream: value.audioPlayerHandler!.audioPlayer
                                      .positionStream,
                                  builder: (context, snapshot) {
                                    return IconButton(
                                        onPressed: () {
                                          value.audioPlayerHandler!.audioPlayer
                                              .seek(Duration(
                                                  seconds: value
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
                                    audioPlayer:
                                        value.audioPlayerHandler!.audioPlayer),
                                StreamBuilder(
                                  stream: value.audioPlayerHandler!.audioPlayer
                                      .positionStream,
                                  builder: (context, snapshot) {
                                    return IconButton(
                                        onPressed: () {
                                          value.audioPlayerHandler!.audioPlayer
                                              .seek(Duration(
                                                  seconds: value
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
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
