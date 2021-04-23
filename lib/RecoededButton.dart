import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videdit/VideoEdit.dart';
//import 'package:video_filter/playRecordedVideo.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  CameraController controller;
  List<CameraDescription> cameras;
  bool cameraInit;

  Future<void> initCamera() async {
    availableCameras().then((value) {
      cameras = value;
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraInit = true;
        });
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    cameraInit = false;
    initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  !cameraInit?Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ): Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(controller),
            ),
            Positioned(
              bottom: 15,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RecordButton(
                      controller: controller,
                    )
                  ],
                ),
              ),
            ),Positioned(
              top: 15,
              left: 0,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back,
                  size: 30,color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget _buildCameraPreview() {
//   final size = MediaQuery.of(context).size;
//   return ClipRect(
//     child: Container(
//       child: Transform.scale(
//         scale: controller.value.aspectRatio / size.aspectRatio,
//         child: Center(
//           child: AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: ,
//           ),
//         ),
//       ),
//     ),
//   );
// }
}


class RecordButton extends StatefulWidget {
  final CameraController controller;
  RecordButton({@required this.controller});
  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  double videoTime = 0.0;
  String videoPath;
  Timer _timer;



  @override
  void initState() {
    super.initState();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {
      });
    });
  }

  void onStopButtonPressed(BuildContext context) async{
      // final Directory extDir = await getApplicationDocumentsDirectory();
      // final String dirPath = '${extDir.path}/Movies/flutter_test';
      // await Directory(dirPath).create(recursive: true);
      // String filePath = '$dirPath/${timestamp()}.mp4';
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        print("233333333333333@@@@@${file.path}");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>
                VideoEditor(path: file.path,
                ),)
        );
      }
    });
  }

  Future<void> startVideoRecording() async {
    if (!widget.controller.value.isInitialized) {
      return;
    }

    if (widget.controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await widget.controller.startVideoRecording();
    } on CameraException catch (e) {
      return;
    }
  }

  Future<XFile> stopVideoRecording() async {
    if (!widget.controller.value.isRecordingVideo) {
      return null;
    }

    try {

      return widget.controller.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  //
  // Future<String> startVideoRecording() async {
  //   if (!widget.controller.value.isInitialized) {
  //     return null;
  //   }
  //

  //
  //   if (widget.controller.value.isRecordingVideo) {
  //     // A recording is already started, do nothing.
  //     return null;
  //   }
  //   try {
  //     setState(() {
  //       videoPath = filePath;
  //     });
  //     await widget.controller.startVideoRecording();
  //   } on CameraException catch (e) {
  //     return null;
  //   }
  //   return filePath;
  // }
  //
  // Future<void> stopVideoRecording() async {
  //   if (!widget.controller.value.isRecordingVideo) {
  //     return null;
  //   }
  //
  //   try {
  //     await widget.controller.stopVideoRecording();
  //   } on CameraException catch (e) {
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    // percentageAnimationController.dispose();
    widget.controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    void startVideo(){
      onVideoRecordButtonPressed();
      _timer = Timer.periodic(
        Duration(seconds: 1),
            (Timer t) => setState(() {
              print(_timer.tick);
          if (_timer.tick==16) {
            _timer.cancel();
            onStopButtonPressed(context);
            // playVideo();
          }
          // percentageAnimationController.forward(from: 0.0);
          // print((t.tick / 1000).toStringAsFixed(0));
        }),
      );
    }

  void  videostop(){
      _timer.cancel();
      onStopButtonPressed(context);
  }

    return  Center(
      child:  Container(
        height: 100.0,
        width: 100.0,
        child:  Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: (){
              _timer==null?startVideo():videostop();
            },
            // onLongPressEnd: (e) {
            //   percentage = 0.0;
            //   newPercentage = 0.0;
            //   timer.cancel();
            //   onStopButtonPressed();
            //   // playVideo();
            // },
            child: Container(
              child: Center(
                child: Text(
                    _timer==null?"Rec":"${_timer.tick}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
              decoration: BoxDecoration(
                color: Color(0xFFee5253),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

// class RecordButtonPainter extends CustomPainter {
//   Color lineColor;
//   Color completeColor;
//   double completePercent;
//   double width;
//   RecordButtonPainter(
//       {this.lineColor, this.completeColor, this.completePercent, this.width});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint line = new Paint()
//       ..color = lineColor
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = width;
//     Paint complete = new Paint()
//       ..color = completeColor
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = width;
//     Offset center = new Offset(size.width / 2, size.height / 2);
//     double radius = min(size.width / 2, size.height / 2);
//     canvas.drawCircle(center, radius, line);
//     double arcAngle = 2 * pi * (completePercent / 9390);
//     canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
//         arcAngle, false, complete);
//   }
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
