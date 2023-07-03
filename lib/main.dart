import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

List images = [
  'https://i.pinimg.com/originals/8c/d0/d7/8cd0d722e65ccd87fffb844980977b3c.jpg',
  'http://4.bp.blogspot.com/_3GTOQGJNP5k/SbCbBCQB3vI/AAAAAAAABIg/PcBhcRjLuVk/s320/halloates.jpg',
  'https://www.billboard.com/files/styles/900_wide/public/media/Metallica-Master-of-Puppets-album-covers-billboard-1000x1000.jpg',
  'https://img.buzzfeed.com/buzzfeed-static/static/2014-10/22/17/campaign_images/webdr04/29-essential-albums-every-90s-kid-owned-2-19453-1414013372-8_dblbig.jpg',
  'https://isteam.wsimg.com/ip/88fde5f6-6e1c-11e4-b790-14feb5d39fb2/ols/580_original/:/rs=w:600,h:600',
  'https://www.covercentury.com/covers/audio/b/baby_justin-bieber_218-vbr_1462296.jpg',
  'https://thebrag.com/wp-content/uploads/2015/10/artvsscienceofftheedgeoftheearthandintoforeverforever1015.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS95jA18s6vnmWIk4z6jTuaINYm4jBoWWRC5yp7cXvwKikEASRR&s'
      'https://list.lisimg.com/image/2239608/500full.jpg',
  'https://images-na.ssl-images-amazon.com/images/I/513D1NEWPXL.jpg'
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const Scaffold(
        body: IPod(),
      ),
    );
  }
}

class IPod extends StatefulWidget {
  const IPod({super.key});

  @override
  IPodState createState() => IPodState();
}

class IPodState extends State<IPod> {
  final PageController _pageCtrl = PageController(viewportFraction: 1);

  double currentPage = 0.0;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // Cover Flow Container
          // Container(
          //   height: 300,
          //   color: Colors.black,
          //   child: PageView.builder(
          //     controller: _pageCtrl,
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 9, //Colors.accents.length,
          //     itemBuilder: (context, int currentIdx) {
          //       return AlbumCard(
          //         color: Colors.accents[currentIdx],
          //         idx: currentIdx,
          //         currentPage: currentPage,
          //       );
          //     },
          //   ),
          // ),
          // Ipod Mini UI
          Container(height: 160, color: Colors.black),
          const SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                height: 20,
                width: 374,
                decoration: const BoxDecoration(color: Colors.grey),
                child: const Text(
                  "   ||                        Ipod Mini                        |=|",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                height: 300,
                width: 374,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListView.builder(
                  controller: _pageCtrl,
                  scrollDirection: Axis.vertical,

                  itemCount: 5, //Colors.accents.length,
                  itemBuilder: (context, int currentIdx) {
                    return IpodUIRow(
                      color: Colors.accents[currentIdx],
                      idx: currentIdx,
                      currentPage: currentPage,
                    );
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onPanUpdate: _panHandler,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Stack(children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 36),
                        child: const Text(
                          'MENU',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 30),
                        child: IconButton(
                          icon: const Icon(Icons.fast_forward),
                          iconSize: 40,
                          onPressed: () => _pageCtrl.animateToPage(
                              (_pageCtrl.page! + 1).toInt(),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 30),
                        child: IconButton(
                          icon: const Icon(Icons.fast_rewind),
                          iconSize: 40,
                          onPressed: () => _pageCtrl.animateToPage(
                              (_pageCtrl.page! - 1).toInt(),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn),
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 30, right: 10),
                          child: RowSuper(
                            alignment: Alignment.center,
                            children: [
                              RowSuper(
                                innerDistance: -10,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("Play/Pause Pressed");
                                    },
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RowSuper(
                                            innerDistance: -10,
                                            children: const [
                                              Icon(
                                                Icons.play_arrow,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              Icon(
                                                Icons.pause,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint("Select Pressed");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= 150; // 150 == radius of circle
    bool onLeftSide = d.localPosition.dx <= 150;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange
        : yChange * -1;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange : xChange * -1;

    // Total computed change with velocity
    double scrollOffsetChange = (horz + vert) * (d.delta.distance * 0.2);

    // Move the page view scroller
    _pageCtrl.jumpTo(_pageCtrl.offset + scrollOffsetChange);
  }
}

class IpodUIRow extends StatelessWidget {
  final Color color;
  final int idx;
  final double currentPage;
  const IpodUIRow(
      {super.key,
      required this.color,
      required this.idx,
      required this.currentPage});
  @override
  Widget build(BuildContext context) {
    bool selected = idx == 0;
    double relativePosition = idx - currentPage;
    Color itemBGColor = selected ? Colors.blueGrey : Colors.grey;
    return ListTile(
      tileColor: itemBGColor,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(vertical: -10.0, horizontal: 20),
      title: const Text(
        "Music",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 24),
      ),
      dense: true,
      titleAlignment: ListTileTitleAlignment.center,
      onTap: () {
        // Set Selected Page
        debugPrint("Selecting Page ${idx.toString()}");
      },
    );
  }
}

class AlbumCard extends StatelessWidget {
  final Color color;
  final int idx;
  final double currentPage;
  const AlbumCard(
      {super.key,
      required this.color,
      required this.idx,
      required this.currentPage});

  @override
  Widget build(BuildContext context) {
    double relativePosition = idx - currentPage;

    return SizedBox(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003) // add perspective
          ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
          ..rotateY(relativePosition),
        // ..rotateZ(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(images[idx]),
            ),
          ),
        ),
      ),
    );
  }
}
