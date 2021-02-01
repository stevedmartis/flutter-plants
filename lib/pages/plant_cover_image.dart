import 'package:chat/models/plant.dart';
import 'package:chat/pages/chat_page.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlantCard extends StatefulWidget {
  PlantCard(
      {@required this.plantColor, @required this.plant, this.isEmpty = false});

  final Color plantColor;
  static const double avatarRadius = 48;
  static const double titleBottomMargin = (avatarRadius * 2) + 18;

  final Plant plant;
  final bool isEmpty;

  final picker = ImagePicker();

  @override
  _PlantCardState createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      // color: currentTheme.scaffoldBackgroundColor,
      child: Hero(
        tag: widget.plant.id,
        child: Material(
            type: MaterialType.transparency,
            child: FadeInImage(
              image: NetworkImage(widget.plant.getCoverImg()),
              placeholder: AssetImage('assets/loading2.gif'),
              fit: BoxFit.cover,
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
            )),
      ),
    );
  }
}

Route createRouteChat() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}