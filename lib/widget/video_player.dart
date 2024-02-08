import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/ui_designs/login_pages/login_page.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Replace 'assets/video.mp4' with the path to your video asset.
    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown and set the state to rebuild the widget.
        setState(() {});
        // Start playing the video when it's initialized.
        _controller.play();
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            // Video has ended, navigate to the login page.
            Get.off(()=>const LoginPage(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 500)
            );
          }
        });
      }).catchError((error) {
        print("Video initialization failed: $error");
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator.adaptive()); // Show a loading indicator until the video is initialized.
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Dispose of the video controller when the widget is disposed.
  }
}