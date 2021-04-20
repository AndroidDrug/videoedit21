import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class DraggerIcons extends StatefulWidget {
  final String path;
  const DraggerIcons({Key key,@required this.path,}) : super(key: key);
  @override
  _DraggerIconsState createState() => _DraggerIconsState();
}

class _DraggerIconsState extends State<DraggerIcons> {
  BetterPlayerController _controller;
  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerData =
    BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.path);
    _controller =  BetterPlayerController(
        BetterPlayerConfiguration(
            autoPlay: false,
            looping: false,
            aspectRatio: 8/17,
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
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('Add Text & Add Emojs',
            style:TextStyle(
                color: Colors.white,fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic
            )),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: (){
              _controller.isPlaying()?_controller.pause():_controller.play();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              child: BetterPlayer(controller: _controller,),
            ),
          ),
          DragText(),
        ],
      ),
    );
  }
}

class DragText extends StatefulWidget {
  @override
  _DragTextState createState() => _DragTextState();
}

class _DragTextState extends State<DragText> {
  Offset offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
            child: SizedBox(
              width: 300,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Hello video Editing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          color: Colors.amber)),
                ),
              ),
            )),
      ),
    );
  }
}

