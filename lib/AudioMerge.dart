import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videdit/VideoEdit.dart';

class AudioMerge extends StatefulWidget {
  final String path;

  const AudioMerge({Key key, @required this.path}) : super(key: key);
  @override
  _AudioMergeState createState() => _AudioMergeState();
}

class _AudioMergeState extends State<AudioMerge> {
  BetterPlayerController _controller;
  Future<void> _videoPlayerControllerFuture;
  File _videoFile;
  String _filename;
  AudioPlayer audioPlayer;

  final spinkit = SpinKitCubeGrid(
    color: Colors.black,
    size: 40.0,
  );

  @override
  void initState() {
    print("@@@@@@@@@@@@@@@@----------------- inside init");
    super.initState();
    // _controller=VideoPlayerController.file(File(widget.path))..initialize().then((value){
    //   setState(() {
    //   });
    // });
    _getVideo();
  }
  _getVideo()  {
    print("@@@@@@@@@@@@@@@@----------------- inside get video");
    print(widget.path);
    // setState(() {});
    BetterPlayerDataSource betterPlayerData =
    BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.path);
    _controller =  BetterPlayerController(
        BetterPlayerConfiguration(
            autoPlay: false,
            looping: false,
            aspectRatio: 8/17,
            fit: BoxFit.contain,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
              enableRetry: false,
              enableProgressBar: false,
              enableSkips: false,
              enableMute: false,
              enableFullscreen: false,
              enableOverflowMenu: false,
            )),
        betterPlayerDataSource: betterPlayerData);
    _videoPlayerControllerFuture=_controller.
    videoPlayerController.
    setFileDataSource(File(widget.path));

  }

  selectAudio() async{
    FilePickerResult video = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
    );
    if (video != null ) {
      print(" video file ...${video.files.single.path}");
      setState(() {
        _videoFile = File(video.files.single.path);
        _filename=video.files.single.name;
        print("++++++++++++++++++++++++++>>>>>>>>>>>>>>>>>>");
        print(_videoFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: Text("Audio Merge",style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic
          )),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: _videoPlayerControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          margin: EdgeInsets.only(top: 50),
                          child: Container(
                            height:400,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  selectAudio();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width:150,
                                  height: 50,
                                  child:Row(
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
                                              Icons.music_note,
                                              size: 35,
                                              color: Colors.pink,
                                            ),
                                          )),
                                      Flexible(
                                        child: Text("Add Audio",style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _videoFile==null?Column():Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text("$_filename",style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic
                                        ),),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            _videoFile=null;
                                          });
                                        },
                                        child: Icon(Icons.cancel_outlined,
                                          size: 20,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AudioPlayers(path:_videoFile.path,
                                    controller: _controller,
                                    totaldutation:_controller.videoPlayerController
                                        .value.duration,videoPath: widget.path,),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return spinkit;
                }),
          ),
        ),
      ),
    );
  }

}

class AudioPlayers extends StatefulWidget {

  final path;
  final BetterPlayerController controller;
  final Duration totaldutation;
  final videoPath;

  const AudioPlayers({Key key, this.path, this.controller,
    this.totaldutation, this.videoPath,}) : super(key: key);
  @override
  _AudioPlayersState createState() => _AudioPlayersState();

}

class _AudioPlayersState extends State<AudioPlayers> {
  FlutterFFmpeg _flutterFFmpeg;
  AnimationController _animationIconController1;
  AudioCache audioCache;
  AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position  = new Duration() ;
  Duration _slider = new Duration(seconds: 0);
  double durationvalue;
  bool issongplaying = false;

  void initState() {
    super.initState();
    _position = _slider;
    // _animationIconController1 = AnimationController(
    //   duration: Duration(milliseconds: 750),
    //   reverseDuration: Duration(milliseconds: 750),
    // );
    audioPlayer = new AudioPlayer();
    audioCache= new AudioCache(fixedPlayer: audioPlayer);
    // audioPlayer.durationHandler = (d) => setState(() {
    //   _duration = d;
    // });
    // audioPlayer.positionHandler = (p) => setState(() {
    //   print("sdiiaskdkjaksjdkajwsd   "+p.inSeconds.toString());
    //   _position = p;
    // });

    // audioPlayer.seek();
    // audioPlayer.onAudioPositionChanged.single.then((value) {
    //   setState(() {
    //     _position=value;
    //   });
    // }
    //  );

    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => _position = d);
    });
    audioPlayer.seek(Duration(milliseconds: 1));
    _flutterFFmpeg=new FlutterFFmpeg();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // void seekToSecond(int seconds) {
  //   Duration newDuration = Duration(seconds: seconds);
  //   //audioPlayer.seek(newDuration);
  // }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),SizedBox(width: 10,),
             Text("Merging audio"),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    print("888888888888888${_position.inSeconds.toDouble()}");
    print("888888888888888${widget.totaldutation.inSeconds.toDouble()}");
    return  Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flexible(
              //   child:
              Slider(
                activeColor: Colors.pink,
                inactiveColor: Colors.pink,
                value: _position.inMilliseconds.toDouble()>
                    widget.totaldutation.inMilliseconds.toDouble()?
                widget.totaldutation.inMilliseconds.toDouble():
                _position.inMilliseconds.toDouble(),
                min:0.0,
                max: widget.totaldutation.inMilliseconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    // seekToSecond(_position.inSeconds);
                    value = value;
                    // if(widget.totaldutation==value)
                    //   {
                    //     audioPlayer.pause();
                    //   }
                  });
                },
              ),
              // ),
              GestureDetector(
                onTap: () {
                  widget.controller.addEventsListener((event) =>{
                    // print('lolololoollolloolooooo${event.betterPlayerEventType}')
                    if(event.betterPlayerEventType == BetterPlayerEventType.finished){
                      audioPlayer.stop(),
                      widget.controller.seekTo(Duration(seconds: 0)),
                      widget.controller.pause()
                    }
                  });
                  setState(
                        () {
                      if (!issongplaying) {
                        audioPlayer.play(widget.path,);
                        widget.controller.play();
                      } else {
                        audioPlayer.pause();
                        widget.controller.pause();
                      }
                      // issongplaying
                      //     ? _animationIconController1.reverse()
                      //     : _animationIconController1.forward();
                      issongplaying = !issongplaying;
                    },
                  );
                },
                child: Icon(
                  issongplaying?Icons.pause_circle_outline:Icons.play_circle_outline,
                  size: 30,
                  color: Colors.pink,),
              )
              // ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              _showDialog();
              String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
              final Directory extDir = await getApplicationDocumentsDirectory();
              final String dirPath = '${extDir.path}/Movies/flutter_test';
              await Directory(dirPath).create(recursive: true);
              final String filePath = '$dirPath/${timestamp()}.mp4';
              print(widget.path);
              print(widget.videoPath);
              print(widget.totaldutation.inSeconds);


              // final arguments=["-y",
              //   "-ss",
              //   "0",
              //   "-t",
              //  "${widget.totaldutation.inSeconds}",
              //   "-i",
              //   "${widget.videoPath}",
              //   "-ss",
              //   "0",
              //   "-i",
              //   "${widget.path}",
              //   "-map", "0:0", "-map", "1:0",
              //   "-acodec", "copy", "-vcodec",
              //   "copy", "-preset", "ultrafast",
              //   "-ss", "0", "-t",
              //   "${widget.totaldutation.inSeconds}",
              //   filePath];
              final arguments = [
                "-i" ,"${widget.videoPath}", "-i", "${widget.path}", "-map",
                "0:v", "-map", "1:a", "-c:v", "copy", "-shortest" ,filePath
              ];

              _flutterFFmpeg.executeWithArguments(arguments).then((result) {
                setState(() {
                  print("-------------------------------------------indide state");
                  if (result == 0) {
                    print('audio created successfully');

                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(
                    //         content: Text('Successfully to generate GIF. Try Again')
                    //     )
                    // );

                    // widget.fileName = "/data/user/0/com.example.flutter_miventus/app_flutter/Movies/flutter_test/1617107038899.mp4";
                    // _fileType = NatureOfFile.Gif;
                    //  widget._onGifGeneratecallback();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context)=>VideoEditor
                          (path:filePath)
                        ));

                  } else {
                    print('Audio failed to create');
                    // _filePath = widget.assetImagePath;
                    // _fileType = NatureOfFile.Asset;
                    // Scaffold.of(context).showSnackBar(
                    // SnackBar(
                    //     content: Text('Failed to generate GIF. Try Again')
                    // )
                    // );
                  }
                });
              });
            },
            child: Center(
              child: Container(
                color: Colors.pink,
                height: 40,
                width: 100,
                child:Center(
                  child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 16),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

