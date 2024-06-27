import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../controller/audio_controller.dart';
import '../controller/main_wrapper_controller.dart';

class SongControl extends StatelessWidget {
  const SongControl({super.key});

  @override
  Widget build(BuildContext context) {
    AudioController audioController =
        Provider.of<AudioController>(context, listen: true);
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onTap: () {
          AppNavigation.router.push('/songControl');
        },
        child: SwipeDetector(
          onSwipeDown: (offset) {
            debugPrint('Swipe down');
            Provider.of<MainWrapperController>(context, listen: false)
                .updateSongControlVisibility(false);
            AudioController audioController =
                Provider.of<AudioController>(context, listen: false);
            audioController.audioPlayerHandler!.stop();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: audioController.audioBook?.image ?? '',
                fit: BoxFit.cover,
                height: 60,
                width: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(audioController.audioBook?.name ?? 'Không rõ',
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold)),
              ),
              StreamBuilder(
                stream: audioController
                    .audioPlayerHandler!.audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final playerState = snapshot.data;
                    final processingState =
                        (playerState as PlayerState)!.processingState;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      );
                    } else if (!audioController
                        .audioPlayerHandler!.audioPlayer.playing) {
                      return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            audioController.audioPlayerHandler!.audioPlayer
                                .play();
                          },
                          icon: const Icon(
                            size: 50,
                            Icons.play_circle,
                            color: AppColors.pink,
                          ));
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            audioController.audioPlayerHandler!.audioPlayer
                                .pause();
                          },
                          iconSize: 50,
                          icon: const Icon(
                            Icons.pause_circle,
                            color: AppColors.pink,
                          ));
                    } else {
                      return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            audioController.audioPlayerHandler!.audioPlayer
                                .seek(Duration.zero);
                          },
                          iconSize: 50,
                          icon: const Icon(
                            Icons.replay_circle_filled_outlined,
                            color: AppColors.pink,
                          ));
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
