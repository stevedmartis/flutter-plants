import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leafety/theme/theme.dart';
import 'package:provider/provider.dart';

class OnboardingMessages extends StatelessWidget {
  final String title;
  final String message;
  final String image;
  final double left;
  final double width;
  final double height;
  const OnboardingMessages(
      {Key key,
      this.title,
      this.message,
      this.image,
      this.left,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: currentTheme.accentColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GTWalsheimPro',
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: _size.height / 20, left: 0),
                width: 400,
                height: _size.height / 2.2,
                child: SvgPicture.asset("assets/images/intro-background.svg",
                    semanticsLabel: 'Acme Logo'),
              ),
              Container(
                margin: EdgeInsets.only(top: _size.height / 6, left: 70),
                width: 250,
                height: _size.height / 4,
                child: SvgPicture.asset(image, semanticsLabel: 'Acme Logo'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
