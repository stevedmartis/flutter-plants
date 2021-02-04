import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/visit_bloc.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/models/plant.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/pages/cover_image_visit.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/visit_service.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateVisitPage extends StatefulWidget {
  AddUpdateVisitPage({this.visit, this.isEdit = false, this.plant});

  final Visit visit;
  final bool isEdit;
  final Plant plant;

  @override
  AddUpdateVisitPageState createState() => AddUpdateVisitPageState();
}

class AddUpdateVisitPageState extends State<AddUpdateVisitPage> {
  Visit visit;
  final degreesCtrl = TextEditingController();

  final electroCtrl = TextEditingController();

  final phCtrl = TextEditingController();

  final mlCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  // final potCtrl = TextEditingController();

  bool isAboutChange = false;

  bool isSwitchedCut = false;

  bool isCutChange = false;

  bool isDegreesChange = false;

  bool isElectoChange = false;

  bool isPhChange = false;

  bool isMlChange = false;

  bool isSwitchedClean = false;

  bool isCleanChange = false;

  bool isSwitchedTemp = false;

  bool isTempChange = false;

  bool isSwitchedWater = false;

  bool isWaterChange = false;

  bool loading = false;

  bool isDefault;

  @override
  void initState() {
    final visitService = Provider.of<VisitService>(context, listen: false);

    visitService.visit = widget.visit;
    visit = visitService.visit;

    // nameCtrl.text = widget.visit.name;
    descriptionCtrl.text = widget.visit.description;

    visitBloc.imageUpdate.add(true);

/*     nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.visit.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
      });
    }); */
    descriptionCtrl.addListener(() {
      setState(() {
        if (widget.visit.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    degreesCtrl.dispose();
    electroCtrl.dispose();
    phCtrl.dispose();
    mlCtrl.dispose();
    descriptionCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final bloc = CustomProvider.visitBlocIn(context);

    final size = MediaQuery.of(context).size;

    final isControllerChange = isAboutChange ||
        isCutChange ||
        isDegreesChange ||
        isElectoChange ||
        isPhChange ||
        isMlChange ||
        isCleanChange ||
        isTempChange ||
        isWaterChange;

    final isControllerChangeEdit = isAboutChange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          (widget.isEdit)
              ? _createButton(bloc, isControllerChangeEdit)
              : _createButton(bloc, isControllerChange),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 30,
          onPressed: () =>
              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context),
          color: Colors.white,
        ),
        title: (widget.isEdit) ? Text('Editar visita') : Text('Nueva visita'),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          //  _snapAppbar();
          // if (_scrollController.offset >= 250) {}
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              // controller: _scrollController,
              slivers: <Widget>[
                SliverFixedExtentList(
                  itemExtent: size.height / 3.7,
                  delegate: SliverChildListDelegate(
                    [
                      StreamBuilder<bool>(
                        stream: visitBloc.imageUpdate.stream,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 200),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        CoverImageVisitPage(
                                            visit: this.visit,
                                            isEdit: widget.isEdit)));
                              },
                              child: Hero(
                                tag: widget.visit.coverImage,
                                child: Image(
                                  image: NetworkImage(
                                    this.visit.getCoverImg(),
                                  ),
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return _buildErrorWidget(snapshot.error);
                          } else {
                            return _buildLoadingWidget();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _createClean(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          _createCut(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          _createTemperature(bloc),
                          (isSwitchedTemp) ? _createDegrees(bloc) : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          _createWater(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          (isSwitchedWater)
                              ? _createElectro(bloc)
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          (isSwitchedWater) ? _createPh(bloc) : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          (isSwitchedWater) ? _createMl(bloc) : Container(),
                          _createDescription(bloc)
                          /*   _createDescription(bloc), */
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _createDescription(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            inputFormatters: [
              new LengthLimitingTextInputFormatter(100),
            ],
            controller: descriptionCtrl,
            //  keyboardType: TextInputType.emailAddress,

            maxLines: 2,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Observación',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createCut(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Cortar',
            style: TextStyle(color: Colors.white.withOpacity(0.60)),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedCut,
            onChanged: (value) {
              setState(() {
                isSwitchedCut = value;

                if (isSwitchedCut != widget.visit.cut) {
                  this.isCutChange = true;
                } else {
                  this.isCutChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createClean(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Limpieza',
            style: TextStyle(color: Colors.white.withOpacity(0.60)),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedClean,
            onChanged: (value) {
              setState(() {
                isSwitchedClean = value;

                if (isSwitchedClean != widget.visit.clean) {
                  this.isCleanChange = true;
                } else {
                  this.isCleanChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createTemperature(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Temperatura',
            style: TextStyle(color: Colors.white.withOpacity(0.60)),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedTemp,
            onChanged: (value) {
              setState(() {
                isSwitchedTemp = value;

                if (isSwitchedCut != widget.visit.temperature) {
                  this.isTempChange = true;
                } else {
                  this.isTempChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createWater(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Regado',
            style: TextStyle(color: Colors.white.withOpacity(0.60)),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedWater,
            onChanged: (value) {
              setState(() {
                isSwitchedWater = value;

                if (isSwitchedWater != widget.visit.water) {
                  this.isWaterChange = true;
                } else {
                  this.isWaterChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createElectro(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.electroStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: electroCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Electro conductor',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeElectro,
          ),
        );
      },
    );
  }

  Widget _createDegrees(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.degreesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            inputFormatters: [
              new LengthLimitingTextInputFormatter(3),
            ],
            controller: degreesCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Grados Co2',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDegrees,
          ),
        );
      },
    );
  }

  Widget _createPh(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.phStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: phCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'pH',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePh,
          ),
        );
      },
    );
  }

  Widget _createMl(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.mlStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: mlCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'ML',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeMl,
          ),
        );
      },
    );
  }

  Widget _createButton(
    VisitBloc bloc,
    bool isControllerChange,
  ) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'Next',
              style: TextStyle(
                  color: (isControllerChange)
                      ? currentTheme.accentColor
                      : Colors.white.withOpacity(0.30),
                  fontSize: 18),
            ),
          ),
        ),
        onTap: isControllerChange && !loading
            ? () => {
                  setState(() {
                    loading = true;
                  }),
                  FocusScope.of(context).unfocus(),
                  (widget.isEdit) ? _editVisit(bloc) : _createVisit(bloc),
                }
            : null);
  }

  _createVisit(VisitBloc bloc) async {
    final visitService = Provider.of<VisitService>(context, listen: false);

    // final Visit = widget.visit.id;
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final clean = isSwitchedClean;

    final temp = isSwitchedTemp;

    final cut = isSwitchedCut;

    final water = isSwitchedWater;

    final degrees =
        (degreesCtrl.text == "") ? widget.visit.degrees : bloc.degrees.trim();

    final electro =
        (electroCtrl.text == "") ? widget.visit.electro : bloc.electro.trim();

    final ph = (phCtrl.text == "") ? widget.visit.ph : bloc.ph.trim();

    final ml = (mlCtrl.text == "") ? widget.visit.ml : bloc.ml.trim();

    final description = (descriptionCtrl.text == "")
        ? widget.visit.description
        : bloc.description.trim();

    final newVisit = Visit(
      // name: name,
      coverImage: widget.visit.coverImage,
      plant: widget.plant.id,
      user: uid,

      clean: clean,
      cut: cut,
      temperature: temp,
      degrees: degrees,
      water: water,
      electro: electro,
      ph: ph,
      ml: ml,
      description: description,
    );

    print(newVisit);

    final createVisitResp = await visitService.createVisit(newVisit);

    if (createVisitResp != null) {
      if (createVisitResp.ok) {
        // widget.plants.add(createPlantResp.plant);
        loading = false;

        Navigator.pop(context);
        setState(() {});
      } else {
        mostrarAlerta(context, 'Error', createVisitResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editVisit(VisitBloc bloc) async {
    final plantService = Provider.of<PlantService>(context, listen: false);
    final awsService = Provider.of<AwsService>(context, listen: false);

    // final uid = authService.profile.user.uid;

    // final name = (bloc.name == null) ? widget.visit.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.visit.description
        : descriptionCtrl.text.trim();

    final editPlant = Plant(
        //   name: name,
        description: description,
        coverImage: awsService.imageUpdate,
        id: widget.visit.id);

    print(editPlant);

    if (widget.isEdit) {
      final editRoomRes = await plantService.editPlant(editPlant);

      if (editRoomRes != null) {
        if (editRoomRes.ok) {
          // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
          // plantBloc.getPlant(widget.visit);
          setState(() {
            loading = false;
          });
          // room = editRoomRes.room;

          Navigator.pop(context);
        } else {
          mostrarAlerta(context, 'Error', editRoomRes.msg);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    }

    //Navigator.pushReplacementNamed(context, '');
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createRouteAddImages(Room room) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewProductPage(
      room: room,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
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