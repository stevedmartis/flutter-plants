import 'package:flutter_plants/bloc/visit_bloc.dart';
import 'package:flutter_plants/models/visit.dart';
import 'package:flutter_plants/services/aws_service.dart';
import 'package:flutter_plants/services/visit_service.dart';
import 'package:flutter_plants/theme/theme.dart';
import 'package:flutter_plants/widgets/cover_image_visit_expanded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CoverImageVisitPage extends StatefulWidget {
  CoverImageVisitPage(
      {this.visit, this.isUserAuth = true, this.isEdit = false});
  final Visit visit;
  final bool isUserAuth;

  final bool isEdit;

  @override
  CoverImageVisitPageState createState() => CoverImageVisitPageState();
}

class CoverImageVisitPageState extends State<CoverImageVisitPage> {
  File imageCover;
  final picker = ImagePicker();
  bool loadImage = false;
  // AwsService authService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUserAuth) if (!widget.isEdit) {
      _selectImage(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          if (widget.isUserAuth)
            (!loadImage)
                ? IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.camera,
                      color: currentTheme.accentColor,
                    ),
                    iconSize: 30,
                    onPressed: () async => (!widget.isEdit)
                        ? _selectImage(true)
                        : _editImage(true),
                    color: Colors.white,
                  )
                : _buildLoadingWidget(),
          if (widget.isUserAuth)
            (!loadImage)
                ? IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate,
                      color: currentTheme.accentColor,
                    ),
                    iconSize: 40,
                    onPressed: () async => (!widget.isEdit)
                        ? _selectImage(false)
                        : _editImage(false),
                    color: Colors.white,
                  )
                : Container(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.visit.coverImage,
        child: Material(
          type: MaterialType.transparency,
          child: ImageCoverVisitExpanded(
            width: 100,
            height: 100,
            visit: widget.visit,
            fontsize: 100,
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

  _selectImage(bool isCamera) async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final visitService = Provider.of<VisitService>(context, listen: false);

    final pickedFile = await picker.getImage(
      source: (isCamera) ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 880,
      maxWidth: 1800,
    );

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        loadImage = true;
      });

      final resp = await awsService.uploadImageCoverVisit(
          fileType[0], fileType[1], imageCover);

      setState(() {
        visitBloc.imageUpdate.add(true);

        widget.visit.coverImage = resp;

        visitService.visit = widget.visit;

        awsService.isUpload = true;

        loadImage = false;

        visitBloc.getVisitsByUser(widget.visit.user);
      });
    } else {
      print('No image selected.');
    }
  }

  _editImage(bool isCamera) async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final visitService = Provider.of<VisitService>(context, listen: false);

    final pickedFile = await picker.getImage(
      source: (isCamera) ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 880,
      maxWidth: 1800,
    );

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        loadImage = true;
      });

      final resp = await awsService.updateImageCoverPlant(
          fileType[0], fileType[1], imageCover, widget.visit.id);

      setState(() {
        visitBloc.imageUpdate.add(true);

        widget.visit.coverImage = resp;

        visitService.visit = widget.visit;

        awsService.isUpload = true;

        loadImage = false;

        visitBloc.getVisitsByUser(widget.visit.user);
      });
    } else {
      print('No image selected.');
    }
  }
}
