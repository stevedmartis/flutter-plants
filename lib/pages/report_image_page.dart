import 'package:chat/models/profiles.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class ReportImagePage extends StatefulWidget {
  ReportImagePage({this.profile, this.isUserAuth = true});
  final Profiles profile;
  final bool isUserAuth;

  @override
  _ReportImagePageState createState() => _ReportImagePageState();
}

class _ReportImagePageState extends State<ReportImagePage> {
  File imageRecipe;

  bool loadingImage = false;

  final pdf = pw.Document();

  // AwsService authService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Page

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final nameSub = (widget.profile.name == "")
        ? widget.profile.user.username
        : widget.profile.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: (widget.isUserAuth) ? Text('Mi Reporte') : Text(nameSub),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 40,
          onPressed: () => {
            setState(() {
              Navigator.pop(context);
            }),
          },

          //  Navigator.pushReplacementNamed(context, '/profile-edit'),
          color: Colors.white,
        ),
        actions: [
          (widget.isUserAuth)
              ? (!loadingImage)
                  ? IconButton(
                      icon: Icon(
                        Icons.share,
                        color: currentTheme.accentColor,
                      ),
                      iconSize: 25,
                      onPressed: () => {},
                      color: Colors.white,
                    )
                  : _buildLoadingWidget()
              : Container(),
          (widget.isUserAuth)
              ? (!loadingImage)
                  ? IconButton(
                      icon: Icon(
                        Icons.file_download,
                        color: currentTheme.accentColor,
                      ),
                      iconSize: 35,
                      onPressed: () async => null,
                      color: Colors.white,
                    )
                  : Container()
              : Container()
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.profile.imageHeader,
        child: Material(
          type: MaterialType.transparency,
          child: RecipeImageExpanded(
            width: 100,
            height: 100,
            profile: widget.profile,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        padding: EdgeInsets.only(right: 10),
        height: 400.0,
        child: Center(child: CircularProgressIndicator()));
  }
}
