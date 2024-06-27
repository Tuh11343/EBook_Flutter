import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/Book.dart';
import '../utils/audio_handler.dart';

class AudioController extends ChangeNotifier {
  AudioPlayerHandler? audioPlayerHandler;
  bool newAudioPlaying = false;

  Book? audioBook;
  String audioAuthor = '';

  Future<void> resetAudio(String audioUrl) async {
    newAudioPlaying = true;
    if (audioPlayerHandler == null) {
      audioPlayerHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(
            audioUrl: audioUrl,
            audioAuthor: audioAuthor,
            audioTitle: audioBook?.name??'Không rõ'),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.app.ebook.audio',
          androidNotificationChannelName: 'Audio Playback',
          androidNotificationOngoing: true,
        ),
      );
    } else {
      await audioPlayerHandler!.reset(audioUrl);
    }
    newAudioPlaying = false;

    notifyListeners();
  }

  void setAudioContent(Book book,String? authorName) {
    audioBook=book;
    audioAuthor = authorName??'Không rõ';
    notifyListeners();
  }
}
