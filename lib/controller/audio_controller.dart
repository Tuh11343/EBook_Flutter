import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';

import '../utils/audio_handler.dart';

class AudioController extends ChangeNotifier {
  AudioPlayerHandler? audioPlayerHandler;
  bool newAudioPlaying = false;

  String audioTitle = '';
  String audioAuthor = '';
  String audioImageURL = '';

  Future<void> resetAudio(String audioUrl) async {
    newAudioPlaying = true;
    if (audioPlayerHandler == null) {
      audioPlayerHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(
            audioUrl: audioUrl,
            audioAuthor: audioAuthor,
            audioTitle: audioTitle),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.app.ebook.audio',
          androidNotificationChannelName: 'Audio Playback',
          androidNotificationOngoing: true,
        ),
      );
    } else {
      audioPlayerHandler!.reset(audioUrl);
    }
    newAudioPlaying = false;

    notifyListeners();
  }

  void setAudioContent(String title, String album, String? imageURL) {
    audioTitle = title;
    audioAuthor = album;
    audioImageURL = imageURL ?? '';
    notifyListeners();
  }
}
