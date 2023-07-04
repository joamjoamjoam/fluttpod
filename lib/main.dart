import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:math' as math;
import 'package:spotify/spotify.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
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
  final ItemScrollController _listViewController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  late ScrollController _scrollController = ScrollController();

  Map<int, dynamic> menuOptionsList = {};

  double currentPage = 0.0;
  int selectedIndex = 0;
  double clickWheelDiameter = 280;
  double clickWheelSelectDiameter = 100;
  bool _listScrollEnabled = true;
  int selectedPage = 0;
  List<int> pageStack = [];
  List<int> indexStack = [];
  Color backColor = const Color.fromARGB(255, 212, 231, 241);
  Color selectedColor = const Color.fromARGB(255, 66, 64, 64);
  Color clickWheelFg = const Color.fromARGB(255, 74, 187, 239);
  Color clickWheelBg = const Color.fromARGB(255, 228, 226, 226);
  int albumNum = 0;
  @override
  void initState() {
    clickWheelSelectDiameter = clickWheelDiameter * .30;
    menuOptionsList[0] = [
      "Music                       >",
      "Settings                  >"
    ];
    menuOptionsList[3] = ["Connect To Spotify", "Theme"];
    final credentials = SpotifyApiCredentials("", "");
    final spotify = SpotifyApi(credentials);
    int previousSize = menuOptionsList[selectedPage].length;
    List<String> newList = List.empty(growable: true);
    List<String> newAlbums = List.empty(growable: true);

    spotify.browse.getNewReleases().all().then((pages) => {
          if (pages.firstOrNull == null)
            {
              print('Empty items'),
            },
          pages.forEach((item) async {
            var tracks = await spotify.albums.getTracks(item.id!).all();
            menuOptionsList[30 + albumNum] = List.empty(growable: true);
            for (var track in tracks) {
              menuOptionsList[30 + albumNum].add("${track.name}-${track.id}");
            }
            albumNum += 1;

            newList.add("${item.artists![0].name}");
            newAlbums.add(item.name!);
            // artists.forEach((artist) {
            //   menuOptionsList[selectedPage + 1]
            //       .add(artist.name);
            // }),
          }),
          if (previousSize != newList.length)
            {
              setState(() {
                menuOptionsList[1] = newList;
                menuOptionsList[2] = newAlbums;
              })
            }
        });
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page!;
      });
    });
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: 350,
      color: const Color.fromARGB(255, 51, 175, 233),
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
          Container(height: 0, color: Colors.black),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                height: 25,
                width: 280,
                decoration: BoxDecoration(color: backColor),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pause,
                      color: Colors.black,
                    ),
                    const Text(
                      "             Ipod Mini            ",
                      style: TextStyle(
                          fontFamily: "RedStar",
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: const Icon(
                        Icons.battery_full_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 260,
                width: 280,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backColor,
                ),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _listViewController,
                  itemPositionsListener: itemPositionsListener,
                  scrollOffsetController: scrollOffsetController,
                  scrollOffsetListener: scrollOffsetListener,
                  scrollDirection: Axis.vertical,
                  itemCount: menuOptionsList[selectedPage].length,
                  itemBuilder: (context, int currentIdx) {
                    return IpodUIRow(
                      backColor: backColor,
                      selectedColor: selectedColor,
                      idx: currentIdx,
                      text: menuOptionsList[selectedPage][currentIdx],
                      selectedIndex: selectedIndex,
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
                    height: clickWheelDiameter,
                    width: clickWheelDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: clickWheelBg,
                    ),
                    child: Stack(children: [
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            if (pageStack.isNotEmpty) {
                              selectedPage = pageStack.last;
                              pageStack.removeLast();
                              selectedIndex = indexStack.last;
                              indexStack.removeLast();
                            }
                          })
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                            'MENU',
                            style: TextStyle(
                                fontFamily: "EpsySans",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: clickWheelFg),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 3),
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.forward_end_alt_fill),
                          iconSize: 40,
                          onPressed: () => {},
                          color: clickWheelFg,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 3),
                        child: IconButton(
                          icon:
                              const Icon(CupertinoIcons.backward_end_alt_fill),
                          iconSize: 40,
                          onPressed: () => {},
                          color: clickWheelFg,
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 10, right: 10),
                          child: RowSuper(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.only(left: 3),
                                child: IconButton(
                                  icon:
                                      const Icon(CupertinoIcons.playpause_fill),
                                  iconSize: 40,
                                  onPressed: () => {},
                                  color: clickWheelFg,
                                ),
                              ),
                            ],
                          ))
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint("Select Pressed for page $selectedIndex");
                    if (selectedPage == 0 || selectedPage == 1) {
                      pageStack.add(selectedPage);
                      indexStack.add(selectedIndex);
                    }
                    setState(() {
                      if (selectedPage == 0) {
                        switch (selectedIndex) {
                          case 0:
                            selectedPage = 1; // Albums
                          case 1:
                            selectedPage = 3; // Settings
                        }
                        selectedIndex = 0;
                      } else if (selectedPage == 1) {
                        selectedPage = 30 + selectedIndex; // Album Tracks
                        selectedIndex = 0;
                      } else if (selectedPage >= 30) {
                        String trackName = menuOptionsList[selectedPage]
                                [selectedIndex]
                            .split('-')[0];
                        String trackID = menuOptionsList[selectedPage]
                                [selectedIndex]
                            .split('-')[1];
                        print("Playing Track $trackName with ID $trackID");
                      }
                      print("set Selected page to $selectedPage");
                    });

                    debugPrint("");
                  },
                  child: Container(
                    height: clickWheelSelectDiameter,
                    width: clickWheelSelectDiameter,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: clickWheelBg,
                        border: Border.all(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    ));
  }

  _handleScroll() {}

  void _panHandler(DragUpdateDetails d) {
    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;
    double radius = clickWheelDiameter / 2;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius; // 150 == radius of circle
    bool onLeftSide = d.localPosition.dx <= radius;
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
    if (d.delta.distance > 3) {
      //double scrollOffsetChange = (horz + vert) * (d.delta.distance * 0.2);

      debugPrint("Scrolling to Index $selectedIndex");
      if (_listScrollEnabled) {
        // Move the page view scroller
        int oldState = selectedIndex;
        if ((horz + vert) < 0) {
          selectedIndex =
              selectedIndex + 1 >= menuOptionsList[selectedPage].length
                  ? menuOptionsList[selectedPage].length - 1
                  : selectedIndex + 1;
        } else {
          selectedIndex = selectedIndex <= 0 ? 0 : selectedIndex - 1;
        }
        if (oldState != selectedIndex) {
          setState(() {
            _listViewController.scrollTo(
                index: selectedIndex,
                duration: const Duration(milliseconds: 200));
            _listScrollEnabled = false;
          });

          Timer(const Duration(milliseconds: 100),
              () => setState(() => _listScrollEnabled = true));
        }
      }
    }
  }
}

class IpodUIRow extends StatelessWidget {
  final Color selectedColor;
  final Color backColor;
  final int idx;
  final int selectedIndex;
  final String text;
  const IpodUIRow(
      {super.key,
      required this.selectedColor,
      required this.backColor,
      required this.idx,
      required this.text,
      required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    bool selected = idx == selectedIndex;
    Color itemBGColor = selected ? selectedColor : backColor;
    return SizedBox(
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 10),
        color: itemBGColor,
        child: Row(
          children: [
            Flexible(
              child: Text(
                text.split("-")[0],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "RedStar",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: selected ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
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
