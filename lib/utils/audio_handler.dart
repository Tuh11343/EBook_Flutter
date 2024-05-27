import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  String audioUrl;
  String? audioTitle;
  String? audioAuthor;
  String? audioImageURL;

  AudioPlayerHandler({
    required this.audioUrl,
    this.audioTitle,
    this.audioAuthor,
    this.audioImageURL,
  }) {
    _init();
  }

  AudioPlayer get audioPlayer => _player;

  Future<void> _init() async {
    await _player.setUrl(audioUrl);
    setMediaPlayer();
  }

  Future<void> reset(String audioUrl) async {
    await _player.setUrl(audioUrl);
    setMediaPlayer();
  }

  void setMediaPlayer() {
    _player.playbackEventStream.listen((event) {
      _setMediaItem();
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.fastForward,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.currentIndex,
      ));
    });
  }

  void _setMediaItem() async {
    String artUriString = audioImageURL ?? '';
    Uri? artUri;

    // Kiểm tra tính hợp lệ của đường dẫn ảnh
    bool isImageUrlValid = await _isValidImageUrl(artUriString);
    artUri = isImageUrlValid ? Uri.parse(artUriString) : null;

    mediaItem.add(MediaItem(
      id: '1',
      album: audioAuthor ?? 'Không rõ',
      title: audioTitle ?? 'Không rõ',
      duration: _player.duration,
      artUri: artUri,
    ));
  }

  Future<bool> _isValidImageUrl(String imageUrl) async {
    try {
      final dio = Dio();
      final response = await dio.head(imageUrl);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> fastForward() =>
      _player.seek(Duration(seconds: _player.position.inSeconds + 10));

  @override
  Future<void> rewind() =>
      _player.seek(Duration(seconds: _player.position.inSeconds - 10));

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

}
