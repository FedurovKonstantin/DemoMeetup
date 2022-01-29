import 'dart:html';

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../main.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 30,
          ),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 600,
              child: HtmlElementView(
                viewType: viewID,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 600,
              child: HtmlElementView(
                viewType: viewID1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
