import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoIntroScreen extends StatefulWidget {
  final String videoPath;
  final Widget nextScreen;
  const VideoIntroScreen({super.key, required this.videoPath, required this.nextScreen});

  @override
  State<VideoIntroScreen> createState() => _VideoIntroScreenState();
}

class _VideoIntroScreenState extends State<VideoIntroScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        // إظهار شريط التحكم (التوقيت) بشكل آمن
        showControls: true,
        autoInitialize: true,
        placeholder: Container(color: Colors.black),
        // تخصيص ألوان الشريط لتناسب تصميم ميرال (أصفر وأورنج)
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.orange,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white,
        ),
      );

      // إضافة المستمع لمراقبة انتهاء الفيديو
      _videoPlayerController.addListener(_videoListener);

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error loading video: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _videoListener() {
    // التأكد أن الفيديو وصل للنهاية ولم نبدأ في عملية الخروج بعد
    if (_videoPlayerController.value.position >= _videoPlayerController.value.duration &&
        _videoPlayerController.value.duration != Duration.zero && !_isExiting) {
      _goToLesson();
    }
  }

  // ✨ الدالة المنقذة: تغلق الصفحة بأمان وتمنع الشاشة الحمراء
  void _goToLesson() {
    if (_isExiting || !mounted) return;
    _isExiting = true;

    // 1. أهم حاجة: وقف المستمع فوراً
    _videoPlayerController.removeListener(_videoListener);

    Future.microtask(() async {
      try {
        // 2. كتم الصوت ووقف الفيديو
        await _videoPlayerController.setVolume(0.0);
        await _videoPlayerController.pause();

        if (mounted) {
          // 3. الانتقال المباشر (استبدال الشاشة)
          // ده هيخلي الـ dispose يشتغل لوحده بهدوء
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.nextScreen),
          );
        }
      } catch (e) {
        debugPrint("Transition Error: $e");
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    // التنظيف هنا بيحصل مرة واحدة بس وبترتيب صح
    _videoPlayerController.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              const Text("خطأ في تحميل الفيديو",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("رجوع للشاشة الرئيسية")
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. الفيديو في الخلفية بملء الشاشة
          Positioned.fill(
            child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
                ? Center(
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              ),
            )
                : const Center(child: CircularProgressIndicator(color: Colors.yellow)),
          ),

          // 2. زرار الإغلاق (X) فوق الفيديو بـ SafeArea للحماية من "النوتش"
          Positioned(
            top: 15,
            left: 15,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => _goToLesson(), // يستخدم نفس الدالة الآمنة
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}