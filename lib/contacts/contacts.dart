import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Contact(
            'Сотрудничество',
            "ev@pharaoh.ru",
            () => launch('mailto:ev@pharaoh.ru?subject=Хорошие треки, друг!!'),
          ),
          Contact(
            'Соцсети',
            "Инстаграм",
            () => launch("https://www.instagram.com/coldsiemens/"),
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final String title;
  final String content;
  final Function action;

  const Contact(
    this.title,
    this.content,
    this.action,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          HoveredText(
            content,
            action,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class HoveredText extends StatefulWidget {
  final String content;
  final TextStyle? style;
  final Function action;
  const HoveredText(this.content, this.action, {this.style});

  @override
  State<HoveredText> createState() => _HoveredTextState();
}

class _HoveredTextState extends State<HoveredText> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.action(),
      child: MouseRegion(
        onEnter: (event) => setState(() {
          isHovered = true;
        }),
        onExit: (event) => setState(() {
          isHovered = false;
        }),
        child: Column(
          children: [
            Text(
              widget.content,
              style: isHovered
                  ? widget.style?.copyWith(
                      decoration: TextDecoration.underline,
                    )
                  : widget.style,
            ),
          ],
        ),
      ),
    );
  }
}
