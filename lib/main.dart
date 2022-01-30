import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pharaoh/clothes/clothes.dart';
import 'package:pharaoh/contacts/contacts.dart';
import 'package:pharaoh/perfect/perfect.dart';
import 'package:pharaoh/videos/videos.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;

void main() async {
  runApp(const MyApp());
}

void setUp() {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Courier',
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final String viewID = "your-view-id";
final String viewID1 = "your-view-id1";

class _HomeState extends State<Home> {
  int currentPage = 1;

  final pages = [
    Perfect(),
    Clothes(),
    Videos(),
    Contacts(),
  ];

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        viewID,
        (int id) => html.IFrameElement()
          ..src = 'https://www.youtube.com/embed/l7v8DAbIOx0'
          ..id = viewID
          ..style.border = 'none');

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        viewID1,
        (int id) => html.IFrameElement()
          ..src = 'https://www.youtube.com/embed/DTzDB5Sr7FI'
          ..style.border = 'none');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationAppBar(changePage),
          Expanded(
            child: pages[currentPage],
          ),
        ],
      ),
    );
  }
}

class NavigationAppBar extends StatefulWidget {
  final Function(int) changePage;
  const NavigationAppBar(this.changePage);

  @override
  _NavigationAppBarState createState() => _NavigationAppBarState();
}

class _NavigationAppBarState extends State<NavigationAppBar> {
  late final pageTitles;

  @override
  void initState() {
    super.initState();
    final style = TextStyle(
      color: Colors.grey,
      fontSize: 20,
    );
    pageTitles = [
      GestureDetector(
        onTap: () {
          widget.changePage(0);
          widget.changePage(2);
          widget.changePage(0);
        },
        child: SvgPicture.asset('assets/logo.svg'),
      ),
      HoveredText(
        "Мерч",
        () async {
          widget.changePage(1);
        },
        style: style,
      ),
      HoveredText(
        "Видео",
        () => widget.changePage(2),
        style: style,
      ),
      HoveredText(
        "Контакты",
        () => widget.changePage(3),
        style: style,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: pageTitles,
      ),
    );
  }
}
