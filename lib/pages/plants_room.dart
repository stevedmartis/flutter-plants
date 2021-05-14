import 'package:flutter_plants/bloc/plant_bloc.dart';

import 'package:flutter_plants/models/air.dart';
import 'package:flutter_plants/models/catalogo.dart';
import 'package:flutter_plants/models/light.dart';

import 'package:flutter_plants/models/plant.dart';
import 'package:flutter_plants/models/products.dart';
import 'package:flutter_plants/models/profiles.dart';

import 'package:flutter_plants/models/room.dart';
import 'package:flutter_plants/pages/add_update_air.dart';
import 'package:flutter_plants/pages/add_update_light.dart';
import 'package:flutter_plants/pages/add_update_plant.dart';
import 'package:flutter_plants/pages/add_update_product.dart';
import 'package:flutter_plants/pages/plant_detail.dart';
import 'package:flutter_plants/pages/profile_page.dart';
import 'package:flutter_plants/pages/room_list_page.dart';
import 'package:flutter_plants/providers/air_provider.dart';
import 'package:flutter_plants/providers/light_provider.dart';
import 'package:flutter_plants/providers/plants_provider.dart';
import 'package:flutter_plants/providers/rooms_provider.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/services/room_services.dart';
import 'package:flutter_plants/widgets/plant_card_widget.dart';

import '../utils//extension.dart';
import 'package:flutter_plants/theme/theme.dart';
import 'package:flutter_plants/widgets/button_gold.dart';
import 'package:flutter_plants/widgets/room_card.dart';
import 'package:flutter_plants/widgets/sliver_appBar_snap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlantsRoomPage extends StatefulWidget {
  final Room room;
  final List<Room> rooms;

  final Product product;

  PlantsRoomPage({@required this.room, this.rooms, this.product});

  @override
  _PlantsRoomPageState createState() => _PlantsRoomPageState();
}

class _PlantsRoomPageState extends State<PlantsRoomPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  final plantService = new PlantsApiProvider();

  final airService = new AiresApiProvider();

  final lightService = new LightApiProvider();

  final roomsApiProvider = new RoomsApiProvider();

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Plants'),
  ];
  TabController _tabController;

  Room room;

  List<Plant> plants = [];

  List<Air> airs = [];

  List<Light> lights = [];

  Profiles profile;
  bool isPlantSelect = false;
  bool loading = false;

  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    _tabController = new TabController(vsync: this, length: myTabs.length);

    final roomService = Provider.of<RoomService>(context, listen: false);

    roomService.room = null;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();

    // roomBloc.disposeRoom();

    plantBloc?.disposePlants();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final roomService = Provider.of<RoomService>(context, listen: false);

    setState(() {
      room = (roomService.room != null) ? roomService.room : widget.room;
    });
    final nameFinal = room.name.isEmpty ? "" : room.name.capitalize();

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            nameFinal,
            style: TextStyle(
                fontSize: 20,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
          ),
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [_createButton(isPlantSelect)],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentTheme.currentTheme.accentColor,
            ),
            iconSize: 30,
            onPressed: () => {
              //plantBloc.plantsSelected.sink.add(false),
              Navigator.pop(context),
            },
            color: Colors.white,
          )),
      body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          slivers: <Widget>[
            //  makeHeaderInfo(context),

            makeHeaderTabs(context),

            (widget.product.id != null)
                ? makeListPlants(context)
                : makeListPlantsRoom(context)
          ]),
    );
  }

  Widget _createButton(
    bool isPlantSelect,
  ) {
    return StreamBuilder(
      stream: plantBloc.plantsSelected.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        final isSelected = (snapshot.data != null)
            ? (snapshot.data.length > 0 ||
                    snapshot.data.length != plants.length)
                ? true
                : false
            : false;
        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Hecho',
                  style: TextStyle(
                      color:
                          (isSelected) ? currentTheme.accentColor : Colors.grey,
                      fontSize: 18),
                ),
              ),
            ),
            onTap: isSelected && !loading
                ? () =>
                    {Navigator.pop(context, true), Navigator.pop(context, true)}
                : null);
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 10,
          maxHeight: 10,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderLoading(context) {
    // final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: 200, maxHeight: 200, child: _buildLoadingWidget()),
    );
  }

  SliverPersistentHeader makeHeaderInfo(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final about = room.description;
    final size = MediaQuery.of(context).size;

    final co2 = room.co2 ? 'Yes' : 'No';
    final co2Control = room.co2Control ? 'Yes' : 'No';
    final timeOn = room.timeOn;
    final timeOff = room.timeOff;

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight:
              (about.length > 10) ? size.height / 2.8 : size.height / 3.0,
          maxHeight:
              (about.length > 10) ? size.height / 2.8 : size.height / 3.0,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0, top: 0),
            color: currentTheme.currentTheme.scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  //margin: EdgeInsets.only(left: size.width / 6, top: 10),
                  width: size.height / 1.3,
                  child: Text(
                    about,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height / 40,
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RowMeassureRoom(
                  wide: room.wide,
                  long: room.long,
                  tall: room.tall,
                  center: true,
                  fontSize: 15.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Co2: ',
                        style: TextStyle(
                            fontSize: size.height / 40.0,
                            color: (currentTheme.customTheme)
                                ? Colors.white54
                                : Colors.black54),
                      ),
                    ),
                    Container(
                      child: Text(
                        '$co2',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height / 40.0,
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      child: Text(
                        'Timer: ',
                        style: TextStyle(
                            fontSize: size.height / 40.0,
                            color: (currentTheme.customTheme)
                                ? Colors.white54
                                : Colors.black54),
                      ),
                    ),
                    Container(
                      child: Text(
                        '$co2Control',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height / 40.0,
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                RowTimeOnOffRoom(
                  timeOn: timeOn,
                  timeOff: timeOff,
                  size: size.height / 40.0,
                  center: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  //top: size.height / 3.5,
                  width: size.width / 2.0,
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: ButtonSubEditProfile(
                        isSecond: true,
                        color: currentTheme.currentTheme.accentColor,
                        textColor: Colors.white,
                        text: 'Editar',
                        onPressed: () {
                          Navigator.of(context)
                              .push(createRouteAddRoom(room, true));
                        }),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Plant findPlant(String id) =>
      plantBloc.plantsSelected.value.firstWhere((plant) => plant.id == id);

  void findPersonUsingLoop(List<Plant> plants, String plantId) {
    for (var i = 0; i < plants.length; i++) {
      if (plants[i].id == plantId) {
        // Found the person, stop the loop
        return;
      }
    }
  }

  /// Find a person in the list using firstWhere method.
  bool findPersonUsingFirstWhere(List<Plant> plants, String plantId) {
    final plant =
        plants.firstWhere((element) => element.id == plantId, orElse: () {
      return null;
    });

    final exist = (plant != null) ? true : false;

    return exist;
  }

  Widget _buildWidgetPlant(plants) {
    return Container(
      child: SizedBox(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: plants.length,
            itemBuilder: (BuildContext ctxt, int index) {
              final plant = plants[index];

              return Container(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0.0),
                  child: CardPlant(
                    plant: plant,
                    isSelected: true,
                  ));
            }),
      ),
    );
  }

  Route createRouteNewProduct(Product product, Catalogo catalogo, bool isEdit) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AddUpdateProductPage(
        product: product,
        catalogo: catalogo,
        isEdit: isEdit,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  SliverList makeListPlants(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: FutureBuilder(
            future: this.plantService.getPlantsRoomSelectedProduct(
                widget.room.id, widget.product.id),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                plants = snapshot.data;
                return (plants.length > 0)
                    ? Container(child: _buildWidgetPlant(plants))
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(50),
                            child: Text(
                              'Sin Plantas para seleccionar',
                              style: TextStyle(
                                fontSize: size.width / 30,
                                color: (currentTheme.customTheme)
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
                            )),
                      ); // image is ready
              } else {
                return _buildLoadingWidget(); // placeholder
              }
            },
          ),
        ),
      ]),
    );
  }

  SliverList makeListPlantsRoom(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: FutureBuilder(
            future: this.plantService.getPlantsRoom(widget.room.id),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                plants = snapshot.data;
                return (plants.length > 0)
                    ? Container(child: _buildWidgetPlant(plants))
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(50),
                            child: Text(
                              'Sin Plantas para seleccionar',
                              style: TextStyle(
                                fontSize: size.width / 30,
                                color: (currentTheme.customTheme)
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
                            )),
                      ); // image is ready
              } else {
                return _buildLoadingWidget(); // placeholder
              }
            },
          ),
        ),
      ]),
    );
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: size.height / 13.0,
        maxHeight: size.height / 13.0,
        child: DefaultTabController(
          length: 1,
          child: Scaffold(
            backgroundColor: currentTheme.scaffoldBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              bottom: TabBar(
                indicatorWeight: 3.0,
                indicatorColor: Colors.grey,
                tabs: [
                  StreamBuilder(
                    stream: plantBloc.plantsSelected.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final isSelected = (snapshot.data != null)
                          ? (snapshot.data.length > 0)
                              ? true
                              : false
                          : false;
                      final countSelection =
                          (isSelected) ? snapshot.data.length : 0;
                      return Tab(
                        child: Text(
                          (isSelected)
                              ? '$countSelection Seleccionadas'
                              : 'Seleccione planta madre',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route createRouteProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
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

Route createRouteNewPlant(Plant plant, Room room, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddUpdatePlantPage(
      plant: plant,
      room: room,
      isEdit: isEdit,
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

Route createRouteNewAir(Air air, Room room, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddUpdateAirPage(
      air: air,
      room: room,
      isEdit: isEdit,
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

Route createRouteNewLight(Light light, Room room, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddUpdateLightPage(
      light: light,
      room: room,
      isEdit: isEdit,
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

Route createRoutePlantDetail(Plant plant, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        PlantDetailPage(plant: plant),
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
