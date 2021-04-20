import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:videdit/RecoededButton.dart';
import 'package:videdit/color.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PageController _tabController;
  @override
  void initState() {
    super.initState();
    //
    _tabController = PageController(initialPage: 0,keepPage: true,viewportFraction: 1.0);
  }

  @override
  void dispose() {

    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
        quarterTurns: 1,
        child: PageView.builder(
          controller: _tabController,
          itemCount:2 ,
          itemBuilder:(BuildContext context,index){
            return RotatedBox(
                quarterTurns: -1,

                child: VideoPlayerItem(size: size,)
            );

          },
        )
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  VideoPlayerItem(
      {Key key,
        @required this.size,
        this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // setState(() {
    // });
    BetterPlayerDataSource betterPlayerData =
    BetterPlayerDataSource(BetterPlayerDataSourceType.network,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4");
    _controller = BetterPlayerController(
        BetterPlayerConfiguration(
            autoPlay: true,
            looping: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
              enableRetry: false,
              enableSkips: false,
              enableMute: true,
              enableFullscreen: false,
              enableOverflowMenu: false,
            )),
        betterPlayerDataSource: betterPlayerData);
  }

  @override
  void dispose() {
    super.dispose();
     _controller.dispose();
  }

  // Widget isPlaying(){
  //   return _videoController.value.isPlaying && !isShowPlaying  ? Container() : Icon(Icons.play_arrow,size: 80,color: white.withOpacity(0.5),);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InkWell(
        onTap: (){
          setState(() {
            _controller.isPlaying()
                ?_controller.pause()
                :_controller.play();
          });
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: AspectRatio(
                aspectRatio: _controller.videoPlayerController.value.aspectRatio,
                child: BetterPlayer(controller: _controller,),
              ),
            ),
            Positioned(
              right: 10.0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RightPanel(
                      size: widget.size,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: size.height * 0.4,
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: getProfile(),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Video()));
                    },),
                ],
              ))
        ],
      ),
    );
  }

}
