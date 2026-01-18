import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // تصميم الـ Singleton لضمان وجود نسخة واحدة فقط من المشغل في كل التطبيق
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();

  // دالة تشغيل الموسيقى (Loop لجعلها لا تتوقف)
  Future<void> playBackgroundMusic() async {
    await _player.setReleaseMode(ReleaseMode.loop); // يجعل الصوت يعيد نفسه تلقائياً
    await _player.play(AssetSource('audio/mix_30s (audio-joiner.com).mp3'));
  }

  // دالة إيقاف الصوت من أي صفحة
  Future<void> stopMusic() async {
    await _player.stop();
  }

  // دالة لخفض الصوت أو رفعه إذا احتجت
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }
}