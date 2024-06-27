import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Protocol.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: _controller.value.isInitialized
            ? Container(
                width: 300,
                height: 178.75,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 168.75,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_controller.value.isPlaying)
                                {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                          ),
                          Icon(
                              _controller.value.isPlaying
                                  ? null
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 60,
                            ),
                        ],
                      ),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                    ),
                  ],
                ),
              )
            // GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         // _controller.value.isPlaying
            //         //     ? _controller.pause()
            //         //     : _controller.play();
            //              _controller.play();
            //       });
            //     },
            //     child: Container(
            //       width: 300,
            //       height: 300,
            //       child: VideoPlayer(_controller),
            //     )
            // Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       AspectRatio(
            //         aspectRatio: _controller.value.aspectRatio,
            //         child: VideoPlayer(_controller),
            //       ),
            //       _controller.value.isPlaying
            //           ? SizedBox.shrink() // Hide button when playing
            //           : GestureDetector(
            //               onTap: () {
            //                 setState(() {
            //                   _controller.value.isPlaying
            //                       ? _controller.pause()
            //                       : _controller.play();
            //                 });
            //               },
            //               child: Container(
            //                 width: 300,
            //                 height: 300,
            //                 decoration: BoxDecoration(
            //                   color: Colors.black54,
            //                   shape: BoxShape.rectangle,
            //                 ),
            //                 // child: Icon(
            //                 //   _controller.value.isPlaying
            //                 //       ? Icons.pause
            //                 //       : Icons.play_arrow,
            //                 //   color: Colors.white,
            //                 //   size: 50,
            //                 // ),
            //               ),
            //             ),
            //     ],
            //   )
            //)
            : CircularProgressIndicator(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
              _controller.setLooping(true);
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }

//   Future<void> initializePlayer() async {
//     _videoPlayerController = VideoPlayerController.asset(
//       'assets/Protocol.mp4',
//     );
//     await _videoPlayerController!.initialize();
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController!,
//       autoPlay: true,
//       looping: true,
//     );
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Player with Timeline')),
//       body: Center(
//         child: _chewieController != null &&
//                 _chewieController!.videoPlayerController.value.isInitialized
//             ? Column(
//                 children: <Widget>[
//                   AspectRatio(
//                     aspectRatio: _videoPlayerController!.value.aspectRatio,
//                     child: Chewie(controller: _chewieController!),
//                   ),
//                   VideoProgressIndicator(
//                     _videoPlayerController!,
//                     allowScrubbing: true,
//                     padding: EdgeInsets.all(10),
//                   ),
//                 ],
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';

// class SamplePlayer extends StatefulWidget {
//   @override
//   _SamplePlayerState createState() => _SamplePlayerState();
// }

// class _SamplePlayerState extends State<SamplePlayer> {
//   late FlickManager flickManager;
//   @override
//   void initState() {
//     super.initState();
//     flickManager = FlickManager(
//       videoPlayerController:
//           VideoPlayerController.asset('assets/Protocol.mp4'),
//         //onVideoEnd: 
//     );
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Container(
//           width: 300,
//           height: 300,
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: FlickVideoPlayer(
//               flickManager: flickManager,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }