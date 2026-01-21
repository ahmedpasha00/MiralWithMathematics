import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isPlaying = false;

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || _isPlaying) return;

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(
        AssetSource('audio/mix_30s (audio-joiner.com).mp3'),
      );
      _isPlaying = true;
    } catch (e) {
      print("Error playing music: $e");
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (!_isPlaying) return;

    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      print("Error pausing music: $e");
    }
  }

  Future<void> stopMusic() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      print("Error stopping music: $e");
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  // لو عندك زر كتم في الإعدادات
  void enableMusic(bool enable) {
    _isMusicEnabled = enable;
    if (!enable) {
      stopMusic();
    }
  }
}
