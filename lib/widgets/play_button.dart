import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayer.playerStateStream,
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
          } else if (!audioPlayer.playing) {
            return IconButton(
                onPressed: () {
                  audioPlayer.play();
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
                  audioPlayer.pause();
                },
                iconSize: 75,
                icon: const Icon(
                  Icons.pause_circle,
                  color: Colors.white,
                ));
          } else {
            return IconButton(
                onPressed: () {
                  audioPlayer.seek(Duration.zero);
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