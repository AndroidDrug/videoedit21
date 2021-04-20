import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:videdit/AudioMerge.dart';
import 'package:videdit/Dragger.dart';
import 'package:videdit/VideoTrim.dart';

class VideoEditor extends StatefulWidget {
  final String path;
  const VideoEditor({Key key, this.path}) : super(key: key);

  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  BetterPlayerController _controller;
  Future _videoPlayerControllerFuture;

  final spinkit = SpinKitDoubleBounce(
    color: Colors.black,
    size: 40.0,
  );

  @override
  void initState() {
    super.initState();
      BetterPlayerDataSource betterPlayerData =
      BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.path);
      _controller = BetterPlayerController(
          BetterPlayerConfiguration(
              autoPlay: false,
              fit: BoxFit.contain,
              looping: false,
              aspectRatio: 5/8,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: true,
                enableRetry: false,
                enableSkips: false,
                enableMute: false,
                enableFullscreen: false,
                enableOverflowMenu: false,
              )),
          betterPlayerDataSource: betterPlayerData);
      _videoPlayerControllerFuture =
          _controller.videoPlayerController.setFileDataSource(File(widget.path));
    }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: Text("Video Editing",style:TextStyle(
              color: Colors.white,fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic
          )),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: _videoPlayerControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          margin: EdgeInsets.only(top: 30),
                          child: Container(
                            height: 400,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: BetterPlayer(controller: _controller),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // GestureDetector(
                              //     onTap: () {
                              //       setState(() {});
                              //       _controller.isPlaying()
                              //           ? _controller.videoPlayerController
                              //               .pause()
                              //           : _controller.videoPlayerController
                              //               .play();
                              //     },
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         _controller.isPlaying()
                              //             ? Icon(
                              //                 Icons.pause_circle_filled,
                              //                 color: Colors.pink,
                              //                 size: 30,
                              //               )
                              //             : Icon(
                              //                 Icons.play_circle_filled,
                              //                 color: Colors.pink,
                              //                 size: 30,
                              //               ),
                              //       ],
                              //     )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayRecordedVideo(
                                                path: widget.path,
                                              )));
                                },
                                child: Container(
                                  width: 80,
                                  height: 120,
                                  child: Column(
                                    children: [
                                      Card(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.cut,
                                              size: 40,
                                              color: Colors.pink,
                                            ),
                                          )),
                                      Flexible(
                                        child: Text("Trim Video",style: TextStyle(
                                          color: Colors.black,

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AudioMerge(
                                                path: widget.path,
                                              )));
                                },
                                child: Container(
                                  width: 80,
                                  height: 120,
                                  child: Column(
                                    children: [
                                      Card(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.library_music_outlined,
                                              size: 40,
                                              color: Colors.pink,
                                            ),
                                          )),
                                      Flexible(
                                        child: Text("Merge Audio",style: TextStyle(
                                            color: Colors.black
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DraggerIcons(
                                                path: widget.path,
                                              )));
                                },
                                child: Container(
                                  width: 80,
                                  height: 120,
                                  child: Column(
                                    children: [
                                      Card(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.app_registration,
                                              size: 40,
                                              color: Colors.pink,
                                            ),
                                          )),
                                      Flexible(
                                        child: Text("Merge Text or Emojs",style: TextStyle(
                                            color: Colors.black
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return spinkit;
              }),
        ),
      ),
    );
  }
}
