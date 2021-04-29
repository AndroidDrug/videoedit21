import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videdit/VideoEdit.dart';

class PlayRecordedVideo extends StatefulWidget {

  final File path;

  PlayRecordedVideo({@required this.path});

  @override
  _PlayRecordedVideoState createState() => _PlayRecordedVideoState();
}

class _PlayRecordedVideoState extends State<PlayRecordedVideo> {
  // final Trimmer _trimmer=Trimmer();
  //String filepath;
  // FlutterFFmpeg fFmpeg;
  File  _image;
  BetterPlayerController _controller;
  Future _videoPlayerControllerFuture;

  final spinkit = SpinKitChasingDots(
    color: Colors.black,
    size: 40.0,
  );

  @override
  void initState() {
    print("@@@@@@@@@@@@@@@@----------------- inside init");
    super.initState();
    _getVideo();
  }

  _getVideo()  {
    print("@@@@@@@@@@@@@@@@----------------- inside get video");
    print(widget.path);
    // setState(() {});
    BetterPlayerDataSource betterPlayerData =
    BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.path.path);
    _controller =  BetterPlayerController(
        BetterPlayerConfiguration(
            autoPlay: false,
            looping: false,
            fit: BoxFit.contain,
            aspectRatio: 5/8,
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
    _videoPlayerControllerFuture= _controller.videoPlayerController.setFileDataSource(widget.path);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: Text("Video Trim",style:TextStyle(
            color: Colors.white,fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic
        )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child:
          FutureBuilder(
              future: _videoPlayerControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState==ConnectionState.done) {
                  return
                    Padding(
                      padding: const EdgeInsets.only(top:20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            child: Container(
                              width: 300,
                              height: 400,
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
                            padding: const EdgeInsets.only(top:20.0),
                            child: SliderContainer(totalDuration: _controller
                                .videoPlayerController.value.duration,
                              controller: _controller,fileName: widget.path.path,),
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

//
// class TrimmerView extends StatefulWidget {
//   final File file;
//
//   const TrimmerView({Key key, @required this.file,}) : super(key: key);
//   @override
//   _TrimmerViewState createState() => _TrimmerViewState();
// }
//
// class _TrimmerViewState extends State<TrimmerView> {
//  Trimmer _trimmer=Trimmer();
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//
//   bool _isPlaying = false;
//   bool _progressVisibility = false;
//
//   Future<String> _saveVideo() async {
//     setState(() {
//       _progressVisibility = true;
//     });
//
//     if(widget.file!=null){
//     await  _trimmer.loadVideo(videoFile: widget.file);
//     }
//
//     String _value;
//
//     await _trimmer
//         .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
//         .then((value) {
//       setState(() {
//         _progressVisibility = false;
//         _value = value;
//       });
//     });
//
//     return _value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("@@@@@@@@@@@@@@@@----------------- inside trimmer video");
//     return Container(
//       width: MediaQuery.of(context).size.width*0.8,
//           child: Column(
//             children: <Widget>[
//               Visibility(
//                 visible: _progressVisibility,
//                 child: LinearProgressIndicator(
//                   backgroundColor: Colors.red,
//                 ),
//               ),
//               RaisedButton(
//                 onPressed: _progressVisibility
//                     ? null
//                     : () async {
//                   _saveVideo().then((outputPath) {
//                     print('OUTPUT PATH: $outputPath');
//                     final snackBar = SnackBar(content: Text('Video Saved successfully'));
//                     // ignore: deprecated_member_use
//                     Scaffold.of(context).showSnackBar(snackBar);
//                   });
//                 },
//                 child: Text("SAVE"),
//               ),
//               // VideoViewer(
//               // ),
//               Center(
//                 child: TrimEditor(
//                   viewerHeight: 50.0,
//                   viewerWidth: MediaQuery.of(context).size.width,
//                   onChangeStart: (value) {
//                     _startValue = value;
//                   },
//                   onChangeEnd: (value) {
//                     _endValue = value;
//                   },
//                   onChangePlaybackState: (value) {
//                     setState(() {
//                       _isPlaying = value;
//                     });
//                   },
//                 ),
//               ),
//               FlatButton(
//                 child: _isPlaying
//                     ? Icon(
//                   Icons.pause,
//                   size: 80.0,
//                   color: Colors.white,
//                 )
//                     : Icon(
//                   Icons.play_arrow,
//                   size: 80.0,
//                   color: Colors.white,
//                 ),
//                 onPressed: () async {
//                   bool playbackState =
//                   await _trimmer.videPlaybackControl(
//                     startValue: _startValue,
//                     endValue: _endValue,
//                   );
//                   setState(() {
//                     _isPlaying = playbackState;
//                   });
//                 },
//               )
//             ],
//           ),
//
//     );
//   }
// }



class SliderContainer extends StatefulWidget {

  final BetterPlayerController controller;
  final  dynamic totalDuration;
  String fileName;
  SliderContainer({Key key, @required this.totalDuration,
    @required this.controller,@required this.fileName,}):
        super(key: key);

  @override
  _SliderContainerState createState() => _SliderContainerState();

// @override
// bool updateShouldNotify( InheritedWidget oldWidget) =>true;
// static SliderContainer of(BuildContext context) =>
//     context.dependOnInheritedElement(SliderContainer);

}

class _SliderContainerState extends State<SliderContainer> {

  FlutterFFmpeg _flutterFFmpeg;
  static double _lowerValue=0;
  static double  _upperValue;
  var _startValue=0;
  var _endValue=0;
  RangeValues _values;

  @override
  void initState() {
    Duration x=widget.totalDuration;
    _upperValue= double.parse((x.inSeconds.toDouble()).toStringAsFixed(2));
    // print("@@@@@@@@@@@@@@@@@@");
    // print(x);
    // print(_upperValue);
    // print("#####################");
    super.initState();
    _values= RangeValues(_lowerValue, _upperValue);
    _flutterFFmpeg = new FlutterFFmpeg();
  }


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
              Text("Saving video"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    print(widget.totalDuration);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ indide slider controller class");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20.0,top: 20.0),
          child: GestureDetector(
              onTap: (){
                setState(() {
                });
                widget.controller.isPlaying()?
                widget.controller.pause() :
                widget.controller.play();

                // widget.controller.isPlaying()?
                // widget.controller.videoPlayerController.refresh():
                // widget.controller.videoPlayerController.refresh();

              },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.controller.isPlaying()?
                  Icon(Icons.pause_circle_filled,color: Colors.pink,size: 30,):
                  Icon(Icons.play_circle_filled,color: Colors.pink,size: 30,),
                ],
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:8.0,right: 8.0),
          child: RangeSlider(
            inactiveColor: Colors.grey[400],
            activeColor: Colors.pink,
            min: _lowerValue,
            max:_upperValue,
            values: _values,
            onChanged: (val) {
              setState(() {
                _values = val;
                _startValue =_values.start.round();
                _endValue =_values.end.round();
                widget.controller.videoPlayerController.seekTo(
                    Duration(hours: 0, minutes: 0, seconds: _startValue.round())
                );
                // widget.controller.betterPlayerConfiguration.startAt=Duration(hours: 0, minutes: 0, seconds: _startValue);
                print(_startValue);
                print(_endValue);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:15.0,right:15.0 ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _startValue.toString(),
                style: TextStyle(color: Colors.pink),
              ),
              Text(
                _endValue==0?_upperValue.toString():_endValue.toString(),
                style: TextStyle(color: Colors.pink),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () async {
            _showDialog();
            String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
            final Directory extDir = await getApplicationDocumentsDirectory();
            final String dirPath = '${extDir.path}/Movies/flutter_test';
            await Directory(dirPath).create(recursive: true);
            final String filePath = '$dirPath/${timestamp()}.mp4';

            print("-------------------------------------------------------------"+_startValue.toString());

            final arguments = [
              "-ss",
              _startValue.toString(),
              "-y",
              "-i",
              widget.fileName,
              "-t",
              _endValue==0?_upperValue.toString():_endValue.toString(),
              "-vcodec",
              "mpeg4",
              "-b:v",
              "2097152",
              "-b:a",
              "48000",
              "-ac",
              "2",
              "-ar",
              "22050",
              filePath
            ];
            _flutterFFmpeg.executeWithArguments(arguments).then((result) {
              setState(() {
                print("-------------------------------------------indide state");
                if (result == 0) {
                  print('Gif created successfully');

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
                        (file:File(filePath))
                      ));

                } else {
                  print('GIF failed to create');
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
    );
  }

}
