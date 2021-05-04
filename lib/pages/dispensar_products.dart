import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:chat/bloc/dispensary_bloc.dart';
import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/subscribe_bloc.dart';
import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/models/air.dart';
import 'package:chat/models/catalogo.dart';
import 'package:chat/models/dispensaries_products_response%20copy.dart';
import 'package:chat/models/dispensary.dart';
import 'package:chat/models/light.dart';

import 'package:chat/models/plant.dart';
import 'package:chat/models/product_principal.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_dispensary.dart';
import 'package:chat/models/profiles.dart';

import 'package:chat/models/room.dart';
import 'package:chat/pages/add_update_air.dart';
import 'package:chat/pages/add_update_light.dart';
import 'package:chat/pages/add_update_plant.dart';
import 'package:chat/pages/add_update_product.dart';
import 'package:chat/pages/plant_detail.dart';
import 'package:chat/pages/product_profile_detail.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/providers/air_provider.dart';
import 'package:chat/providers/light_provider.dart';
import 'package:chat/providers/plants_provider.dart';
import 'package:chat/providers/rooms_provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/dispensary_service.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/productProfile_card.dart';
import 'package:chat/widgets/room_card.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:chat/widgets/text_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class DispensarProductPage extends StatefulWidget {
  final Profiles profileUser;
  final DispensariesProduct dispensaryProducts;
  final ProductDispensaryBloc productsDispensaryBloc;

  DispensarProductPage(
      {@required this.profileUser,
      this.dispensaryProducts,
      @required this.productsDispensaryBloc});

  @override
  _DispensarProductPageState createState() => _DispensarProductPageState();
}

class _DispensarProductPageState extends State<DispensarProductPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  final plantService = new PlantsApiProvider();

  final airService = new AiresApiProvider();

  final lightService = new LightApiProvider();
  SocketService socketService;
  final roomsApiProvider = new RoomsApiProvider();

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Plants'),
  ];
  TabController _tabController;

  final productDispensaryBloc2 = new ProductDispensaryBloc();

  Room room;

  List<Plant> plants = [];

  List<Air> airs = [];

  List<Light> lights = [];

  Profiles profile;
  bool isPlantSelect = false;
  bool loading = false;

  bool isSelected = false;

  bool isDispensaryActive = false;
  bool isDispensary = false;
  bool isDispensaryDelivered = false;

  int quantitysTotal = 0;

  bool loadingData = false;
  bool isEdit = false;

  List<ProductProfile> dispensaryProductsLikes = [];
  DispensariesProduct dispensaryProducts;

  List<ProductProfile> dispensaryProductsNotLikes = [];

  final productsLikedBloc = ProductBloc();

  final gramsRecipeController = TextEditingController();

  String setDateG;

  bool isGramChange = false;

  bool isDateChange = false;
  bool errorRequired = false;
  int initialQuantity = 0;
  int itemsInitial = 0;

  DateTime selectedDateG = DateTime.now();
  TextEditingController _dateGController = TextEditingController();

  Future<Null> _selectDateGermina(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateG,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateG = picked;
        _dateGController.text = DateFormat('dd/MM/yyyy').format(selectedDateG);
      });
  }

  @override
  void initState() {
    super.initState();

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;
    this.socketService = Provider.of<SocketService>(context, listen: false);

    gramsRecipeController.addListener(() {
      final gram = (gramsRecipeController.text == "")
          ? 0
          : int.parse(gramsRecipeController.text);
      setState(() {
        if (gram != widget.dispensaryProducts.gramsRecipe)
          this.isGramChange = true;
        else
          this.isGramChange = false;

        if (gramsRecipeController.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });

    _dateGController.addListener(() {
      setState(() {
        if (_dateGController.text != widget.dispensaryProducts.dateDelivery)
          this.isDateChange = true;
        else
          this.isDateChange = false;
      });
    });

    getDispensaryActiveByUser();

    _tabController = new TabController(vsync: this, length: myTabs.length);

    final roomService = Provider.of<RoomService>(context, listen: false);

    roomService.room = null;

    (profile.isClub)
        ? productsLikedBloc.getDispensaryProductsProfile(profile.user.uid,
            widget.profileUser.user.uid, widget.dispensaryProducts.id)
        : productsLikedBloc.getDispensaryProductsProfile(
            widget.dispensaryProducts.club,
            widget.profileUser.user.uid,
            widget.dispensaryProducts.id);
  }

  void getDispensaryActiveByUser() async {
    setState(() {
      itemsInitial = widget.dispensaryProducts.productsDispensary.length;
      isDispensary = widget.dispensaryProducts.isActive;
      loadingData = true;
      isEdit = widget.dispensaryProducts.isEdit;
      isDispensaryDelivered = widget.dispensaryProducts.isDelivered;
    });

    isDispensaryActive = widget.dispensaryProducts.isActive;

    gramsRecipeController.text =
        (widget.dispensaryProducts.gramsRecipe).toString();
    _dateGController.text = widget.dispensaryProducts.dateDelivery;

    if (isDispensary) {
      productDispensaryBloc2.productsDispensary.value = [];
      initialQuantity =
          (widget.dispensaryProducts.productsDispensary.length > 0)
              ? widget.dispensaryProducts.productsDispensary
                  .map((Product item) => item.quantityDispensary)
                  .reduce((item1, item2) => item1 + item2)
              : 0;

      if (widget.dispensaryProducts.productsDispensary.length > 0)
        quantitysTotal = widget.dispensaryProducts.productsDispensary
            .map((Product item) => item.quantityDispensary)
            .reduce((item1, item2) => item1 + item2);
    } else {
      initialQuantity = 0;
      quantitysTotal = 0;
    }

    // productDispensaryBloc2.productDispensary.sink.add(dispensaryProductsActive);

    productDispensaryBloc2.gramsRecipeAdd.sink
        .add((widget.dispensaryProducts.gramsRecipe).toString());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();

    dispensaryProducts = null;

    //  widget.productsDispensaryBloc.dispose();
    gramsRecipeController.dispose();
    //productDispensaryBloc.dispose();

    // roomBloc.disposeRoom();

    productsLikedBloc.dispose();

    plantBloc?.disposePlants();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.profileUser.name,
            style: TextStyle(
                fontSize: 20,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
          ),
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [_createButton()],
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              //  makeHeaderInfo(context),
              makeFormDispensary(context),
              // makeHeaderTabs(context),
              makeListProducts(
                  context) /*  (widget.product.id != null)
                  ? makeListPlants(context)
                  : makeListPlantsRoom(context) */
            ]),
      ),
    );
  }

  Widget _createButton() {
    return StreamBuilder(
      stream: productDispensaryBloc2.productsDispensary.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        final isSelected = (snapshot.data != null)
            ? (snapshot.data.length > 0)
                ? true
                : false
            : false;

        final quantity = (isSelected)
            ? snapshot.data
                .map((Product item) => item.quantityDispensary)
                .reduce((item1, item2) => item1 + item2)
            : null;

        final int items = (isSelected) ? snapshot.data.length : itemsInitial;

        final isQuantity = (quantity != null) ? quantity : initialQuantity;
        return (!isDispensaryDelivered && profile.isClub)
            ? GestureDetector(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (isDispensary &&
                            !isGramChange &&
                            isQuantity > 0 &&
                            !isDateChange &&
                            isQuantity == initialQuantity &&
                            itemsInitial == items)
                        ? Center(
                            child: Text(
                            'Entregar',
                            style: TextStyle(
                                color: currentTheme.accentColor, fontSize: 18),
                          ))
                        : Center(
                            child: (initialQuantity == 0 && !isDispensary)
                                ? Text('Hecho',
                                    style: TextStyle(
                                        color: (!errorRequired && isGramChange)
                                            ? currentTheme.accentColor
                                            : Colors.grey,
                                        fontSize: 18))
                                : (isQuantity > 0 && isDispensary ||
                                        isGramChange ||
                                        initialQuantity != isQuantity ||
                                        isDateChange ||
                                        itemsInitial != items)
                                    ? Text(
                                        'Editar',
                                        style: TextStyle(
                                            color: currentTheme.accentColor,
                                            fontSize: 18),
                                      )
                                    : Container(),
                          )),
                onTap: () => {
                      (isDispensary &&
                              initialQuantity == isQuantity &&
                              !isGramChange &&
                              !isDateChange)
                          ? showAlertDispesary(
                              'Entregar Pedido',
                              'Se Cambiara el estado a Entregado y se notificara al miembro.',
                              false,
                              true)
                          : (loadingData)
                              ? (initialQuantity == 0 && !isDispensary)
                                  ? {
                                      showAlertDispesary(
                                          'Crear Pedido',
                                          'Se Creara con estado en curso y se notificara al miembro',
                                          false,
                                          false)
                                    }
                                  : (isDispensary ||
                                          isGramChange ||
                                          initialQuantity != isQuantity ||
                                          isDateChange)
                                      ? showAlertDispesary(
                                          'Editar Pedido',
                                          'Se Editara y se notificara al miembro',
                                          true,
                                          false)
                                      : null
                              : null,
                    })
            : Container();
      },
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: currentTheme.currentTheme.cardColor,
      content: EmojiText(
          text: text,
          style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
              fontSize: 15),
          emojiFontMultiplier: 1.5),
    ));
  }

  alertToCreateDispensary(
      String title, String subTitle, bool isEdit, bool isDelivered) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    return AlertDialog(
      backgroundColor: currentTheme.cardColor,
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
      content: Text(
        subTitle,
        style: TextStyle(color: Colors.white54),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.white54),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
            child: Text(
              'Aceptar',
              style: TextStyle(color: currentTheme.accentColor),
            ),
            onPressed: () => {
                  (!isDelivered)
                      ? createUpdateDispensary(isEdit)
                      : dispensaryDelivered(context)
                }),
      ],
    );
  }

  showAlertDispesary(
      String title, String subTitle, bool isEdit, bool isDelivered) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: currentTheme.cardColor,
                title: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  subTitle,
                  style: TextStyle(color: Colors.white54),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white54),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                      child: Text(
                        'Aceptar',
                        style: TextStyle(color: currentTheme.accentColor),
                      ),
                      onPressed: () => {
                            (!isDelivered)
                                ? createUpdateDispensary(isEdit)
                                : dispensaryDelivered(context)
                          }),
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                subTitle,
                style: TextStyle(color: Colors.white54),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: currentTheme.accentColor),
                  ),
                  onPressed: () => {
                    (!isDelivered)
                        ? createUpdateDispensary(isEdit)
                        : dispensaryDelivered(context)
                  },
                ),
              ],
            ));
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

/*   Widget _buildWidgetPlant(plants) {
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
  } */

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

  SliverList makeListProducts(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(top: 20),
                child: StreamBuilder<DispensaryProductsProfileResponse>(
                  stream: productsLikedBloc.dispensaryProducts.stream,
                  builder: (context,
                      AsyncSnapshot<DispensaryProductsProfileResponse>
                          snapshot) {
                    if (snapshot.hasData) {
                      final List<ProductProfile> allProducts =
                          snapshot.data.productsProfileDispensary;

                      productDispensaryBloc2.productsProfileDispensary.sink
                          .add(allProducts);

                      dispensaryProductsLikes =
                          allProducts.where((i) => i.product.isLike).toList();

                      dispensaryProductsNotLikes =
                          allProducts.where((i) => !i.product.isLike).toList();

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (dispensaryProductsLikes.length > 0 &&
                                    profile.isClub)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: 0, left: 20, bottom: 15),
                                    child: Text(
                                      'Favoritos',
                                      style: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(
                                        top: 0, left: 20, bottom: 15),
                                    child: Text(
                                      'Tratamientos',
                                      style: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                            if (dispensaryProductsLikes.length > 0)
                              _buildDispensaryProducts(dispensaryProductsLikes),
                            if (dispensaryProductsNotLikes.length > 0 &&
                                profile.isClub)
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, left: 20, bottom: 15),
                                child: Text(
                                  'En Stock',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            if (dispensaryProductsNotLikes.length > 0)
                              _buildDispensaryProducts(
                                  dispensaryProductsNotLikes)
                          ]);
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error);
                    } else {
                      return _buildLoadingWidget();
                    }
                  },
                )),
          ],
        ),
      ]),
    );
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

  Widget _buildDispensaryProducts(List<ProductProfile> productsProfile) {
    productsProfile.sort((ProductProfile a, ProductProfile b) =>
        b.product.id.compareTo(a.product.id));

    return Container(
        child: SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: productsProfile.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final productProfile = productsProfile[index];

            return (!profile.isClub)
                ? _buildWidgetProducts(productProfile, index)
                : _buildWidgetProductsForClub(productProfile);
          }),
    ));
  }

  Widget _buildWidgetProducts(ProductProfile productProfile, int index) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        FadeInLeft(
          delay: Duration(milliseconds: 300 * index),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: size.height / 30,
            ),
            child: OpenContainer(
                closedElevation: 5,
                openElevation: 5,
                closedColor: currentTheme.currentTheme.scaffoldBackgroundColor,
                openColor: currentTheme.currentTheme.scaffoldBackgroundColor,
                transitionType: ContainerTransitionType.fade,
                openShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                ),
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                ),
                openBuilder: (_, closeContainer) {
                  return ProductProfileDetailPage(
                      productProfile: productProfile, isUserAuth: false);
                },
                closedBuilder: (_, openContainer) {
                  return Stack(
                    children: [
                      Container(
                        child:
                            CardProductProfile(productProfile: productProfile),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetProductsForClub(ProductProfile productsProfile) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Container(
        child: Stack(
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 10),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: (currentTheme.customTheme)
                          ? currentTheme.currentTheme.cardColor
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0))),

                  // padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5.0),
                  width: size.height / 1.5,
                  child: FittedBox(
                    child: Stack(
                      children: [
                        Row(
                          children: <Widget>[
                            productItem(
                              true,
                              productsProfile.product,
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(10.0)),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: (productsProfile
                                                .product.coverImage !=
                                            "")
                                        ? cachedNetworkImage(productsProfile
                                            .product
                                            .getCoverImg())
                                        : FadeInImage(
                                            image: AssetImage(
                                                'assets/images/empty_image.png'),
                                            placeholder: AssetImage(
                                                'assets/loading2.gif'),
                                            fit: BoxFit.cover),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )

            /*  CardProduct(
                          product: product,
                          isDispensary: true,
                          quantitysTotal: quantitysTotal,
                          productsUserDispensaryBloc:
                              productsUserDispensaryBloc,
                          isActive: isDispensaryActive,
                        ) */
            ),
        if (!profile.isClub)
          buildCircleQuantutyProductProfile(
              context, productsProfile.product.quantityDispensary),

        /* buildCircleFavoriteProductProfile(
                                  context, productProfiles.product.isLike), */
      ],
    ));
  }

  Container buildCircleQuantutyProductProfile(context, int quantity) {
    final size = MediaQuery.of(context).size;
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(left: size.width / 1.4, top: 0.0),
        width: 120,
        height: 120,
        child: CircleAvatar(
            child: Text(
              '$quantity',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            backgroundColor: Colors.black));
  }

  Widget productItem(
    bool isDispensary,
    Product product,
  ) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    final thc = (product.thc.isEmpty) ? '0' : product.thc;
    final cbd = (product.cbd.isEmpty) ? '0' : product.cbd;
    final rating = product.ratingInit;
    final about = product.description;

    var ratingDouble = double.parse('$rating');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  product.name.capitalize(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: currentTheme.currentTheme.accentColor),
                ),
              ),
              CbdthcRow(
                thc: '$thc',
                cbd: '$cbd',
                fontSize: 9.0,
              ),
              if (!isDispensary)
                SizedBox(
                  height: 5.0,
                ),
              if (!isDispensary)
                Container(
                  width: size.width / 3.5,
                  child: Text(
                    (about.length > 0) ? about.capitalize() : "Sin descripción",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.grey),
                  ),
                ),
              SizedBox(
                height: (about.length < 20 || isDispensary) ? 10 : 0.0,
              ),
              (isDispensary)
                  ? StreamBuilder(
                      stream: productDispensaryBloc2.gramsStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        final isSelected = (snapshot.data != null)
                            ? (snapshot.data != "")
                                ? true
                                : false
                            : false;

                        final gram =
                            (isSelected) ? int.parse(snapshot.data) : 0;

                        if (!isDispensaryActive) if (gram == 0 ||
                            gram < product.quantityDispensary) {
                          product.quantityDispensary = 0;
                          productDispensaryBloc2.productsDispensary.value = [];

                          productDispensaryBloc2.productsDispensary.sink.add(
                              productDispensaryBloc2.productsDispensary.value);
                        }

                        Timer(Duration(seconds: 1),
                            () => {isDispensaryActive = false});

                        return Container(
                          width: size.width / 3.5,
                          height: size.height / 25,
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentTheme
                                  .currentTheme.scaffoldBackgroundColor),
                          child: Row(
                            children: [
                              Material(
                                color: currentTheme
                                    .currentTheme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  splashColor:
                                      (!isDispensaryDelivered && profile.isClub)
                                          ? Colors.grey
                                          : Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  radius: 25,
                                  onTap: () {
                                    if (!isDispensaryDelivered &&
                                        profile.isClub) if (product
                                            .quantityDispensary >
                                        0) {
                                      setState(() {
                                        product.quantityDispensary--;
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());

                                        final item = productDispensaryBloc2
                                            .productsDispensary.value
                                            .firstWhere(
                                                (item) => item.id == product.id,
                                                orElse: () => null);
                                        if (item != null) {
                                          setState(() => {
                                                item.quantityDispensary =
                                                    product.quantityDispensary,
                                                productDispensaryBloc2
                                                    .productsDispensary.sink
                                                    .add(productDispensaryBloc2
                                                        .productsDispensary
                                                        .value)
                                              });
                                        } else {
                                          setState(() => {
                                                productDispensaryBloc2
                                                    .productsDispensary.value
                                                    .add(product),
                                                productDispensaryBloc2
                                                    .productsDispensary.sink
                                                    .add(productDispensaryBloc2
                                                        .productsDispensary
                                                        .value)
                                              });
                                        }
                                      });
                                    }
                                  },
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    child: Icon(
                                      Icons.remove,
                                      color: (isDispensaryDelivered ||
                                              !profile.isClub)
                                          ? Colors.grey
                                          : currentTheme
                                              .currentTheme.accentColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(),
                                  child: Text(
                                    product.quantityDispensary.toString(),
                                    style: TextStyle(
                                      color: (isDispensaryDelivered ||
                                              !profile.isClub)
                                          ? Colors.grey
                                          : currentTheme
                                              .currentTheme.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                  color: currentTheme
                                      .currentTheme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    splashColor: (!isDispensaryDelivered &&
                                            profile.isClub)
                                        ? Colors.grey
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    radius: 25,
                                    onTap: () {
                                      if (!isDispensaryDelivered &&
                                          profile.isClub) if (product
                                                  .quantityDispensary <
                                              gram &&
                                          gram != quantitysTotal) {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          product.quantityDispensary++;

                                          if (productDispensaryBloc2
                                                  .productsDispensary.value !=
                                              null) {
                                            final findItem =
                                                productDispensaryBloc2
                                                    .productsDispensary.value
                                                    .firstWhere(
                                                        (item) =>
                                                            item.id ==
                                                            product.id,
                                                        orElse: () => null);

                                            if (findItem == null) {
                                              productDispensaryBloc2
                                                  .productsDispensary.value
                                                  .add(product);

                                              productDispensaryBloc2
                                                  .productsDispensary.sink
                                                  .add(productDispensaryBloc2
                                                      .productsDispensary
                                                      .value);
                                            } else {
                                              findItem.quantityDispensary =
                                                  product.quantityDispensary;
                                              productDispensaryBloc2
                                                  .productsDispensary.sink
                                                  .add(productDispensaryBloc2
                                                      .productsDispensary
                                                      .value);
                                            }
                                          } else {
                                            productDispensaryBloc2
                                                .productsDispensary.value
                                                .add(product);

                                            productDispensaryBloc2
                                                .productsDispensary.sink
                                                .add(productDispensaryBloc2
                                                    .productsDispensary.value);
                                          }
                                        });
                                      }
                                    },
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      child: Icon(
                                        Icons.add,
                                        color: (isDispensaryDelivered ||
                                                !profile.isClub)
                                            ? Colors.grey
                                            : currentTheme
                                                .currentTheme.accentColor,
                                        size: 15,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      })
                  : Container(),
              if (isDispensary) const SizedBox(height: 10),
              (!isDispensary)
                  ? Container(
                      padding: EdgeInsets.only(left: 0, top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (ratingDouble >= 1)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 2)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 3)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 4)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble == 5)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

/*   SliverList makeListPlantsRoom(context) {
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
  } */

  SliverToBoxAdapter makeFormDispensary(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => {
              (!isDispensaryDelivered && profile.isClub)
                  ? _selectDateGermina(context)
                  : null,
              FocusScope.of(context).requestFocus(new FocusNode())
            },
            child: AbsorbPointer(
              child: TextFormField(
                enabled: !isDispensaryDelivered && profile.isClub,
                style: TextStyle(
                  color:
                      (currentTheme.customTheme) ? Colors.white : Colors.black,
                ),
                controller: _dateGController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: (currentTheme.customTheme)
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelStyle: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                  // icon: Icon(Icons.perm_identity),
                  //  fillColor: currentTheme.accentColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: currentTheme.currentTheme.accentColor,
                        width: 2.0),
                  ),
                  labelText: 'Fecha Entrega',

                  icon: Icon(Icons.event,
                      color: (currentTheme.customTheme)
                          ? Colors.white54
                          : Colors.black54),

                  //labelText: 'Ancho *',

                  //counterText: snapshot.data,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: _createGramsRecipe(),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                if (isDispensary && !isDispensaryDelivered)
                  Chip(
                    avatar: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.pending)),
                    label: Text('En Curso'),
                  ),
                if (isDispensary && isDispensaryDelivered)
                  Chip(
                    backgroundColor: currentTheme.currentTheme.accentColor,
                    avatar: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.check,
                          color: currentTheme.currentTheme.accentColor,
                        )),
                    label: Text(
                      'Entregado',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                if (isDispensary) SizedBox(width: 10),
                if (isDispensary)
                  (isEdit)
                      ? Chip(
                          avatar: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(Icons.edit_rounded)),
                          label: Text('Editado'),
                        )
                      : Container(),
                if (!isDispensary)
                  Container(
                      child: Text(' ',
                          style: TextStyle(
                              color: (currentTheme.customTheme)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                Spacer(),
                StreamBuilder(
                  stream: productDispensaryBloc2.productsDispensary.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final isSelected = (snapshot.data != null)
                        ? (snapshot.data.length > 0)
                            ? true
                            : false
                        : false;

                    quantitysTotal = (isSelected)
                        ? snapshot.data
                            .map((Product item) => item.quantityDispensary)
                            .reduce((item1, item2) => item1 + item2)
                        : (isDispensaryActive)
                            ? initialQuantity
                            : quantitysTotal--;

                    return Row(
                      children: [
                        Container(
                          child: Text(
                            'Total: ',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            '$quantitysTotal',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                )
                /*  SizedBox(
                        width: 20,
                      ),
                      Chip(
                        backgroundColor: currentTheme.currentTheme.accentColor,
                        avatar: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(Icons.check_rounded)),
                        label: Text(
                          'Entregar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ), */
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget _createGramsRecipe() {
    return StreamBuilder(
      stream: productDispensaryBloc2.productsDispensary.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            onTap: () => {
              if (!isDispensaryDelivered && profile.isClub)
                if (gramsRecipeController.text == "0")
                  gramsRecipeController.text = "",
              setState(() {})
            },
            enabled: !isDispensaryDelivered && profile.isClub,
            controller: gramsRecipeController,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                icon: FaIcon(
                  FontAwesomeIcons.handHoldingMedical,
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                labelText: 'Gramos recetados *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: productDispensaryBloc2.changeGrams,
          ),
        );
      },
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
                    stream: productDispensaryBloc2.productsDispensary.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final isSelected = (snapshot.data != null)
                          ? (snapshot.data.length > 0)
                              ? true
                              : false
                          : false;
                      final quantitysTotalNew = (isSelected)
                          ? snapshot.data
                              .map((Product item) => item.quantityDispensary)
                              .reduce((item1, item2) => item1 + item2)
                          : 0;

                      return Tab(
                        child: Text(
                          (isSelected)
                              ? 'Total Dispensar: $quantitysTotalNew'
                              : 'Dispensar Tratamiento ',
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

  createUpdateDispensary(bool isEdit) async {
    final dispensaryService =
        Provider.of<DispensaryService>(context, listen: false);

    setState(() {
      loading = true;
    });

    Navigator.pop(context);

    final gramRecipe = (productDispensaryBloc2.gramsRecipe == null)
        ? productDispensaryBloc2.gramsRecipe
        : productDispensaryBloc2.gramsRecipe;

    final dateDelivery = _dateGController.text;

    final dispensaryPost = Dispensary(
        id: widget.dispensaryProducts.id,
        subscriptor: widget.profileUser.user.uid,
        club: profile.user.uid,
        gramsRecipe: int.parse(gramRecipe),
        dateDelivery: dateDelivery);

    final productsDispensary = productDispensaryBloc2.productsDispensary.value;

    if (!isEdit) {
      final createDispensary = await dispensaryService.createDispensary(
          dispensaryPost, productsDispensary);

      if (createDispensary != null) {
        if (createDispensary.ok) {
          loading = false;
          subscriptionBloc.getSubscriptionsApprove(profile.user.uid);

          widget.productsDispensaryBloc.getDispensariesProducts(
              profile.user.uid, widget.profileUser.user.uid);

          this.socketService.emit('principal-notification',
              {'by': profile.user.uid, 'for': widget.profileUser.user.uid});

          Navigator.pop(context);
          _showSnackBar(context, 'Pedido en Curso y Notificado 👍');
          setState(() {});
        } else {
          mostrarAlerta(context, 'Error', createDispensary.msg);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    } else {
      final updateDispensary = await dispensaryService.updateDispensary(
          dispensaryPost, productsDispensary);

      if (updateDispensary != null) {
        if (updateDispensary.ok) {
          loading = false;
          subscriptionBloc.getSubscriptionsApprove(profile.user.uid);

          widget.productsDispensaryBloc.getDispensariesProducts(
              profile.user.uid, widget.profileUser.user.uid);

          this.socketService.emit('principal-notification',
              {'by': profile.user.uid, 'for': widget.profileUser.user.uid});

          Navigator.pop(context);

          _showSnackBar(context, 'Pedido Editado y Notificado 👍');
          setState(() {});
        } else {
          mostrarAlerta(context, 'Error', updateDispensary.msg);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    }
  }

  dispensaryDelivered(context) async {
    Navigator.pop(context);

    final dispensaryService =
        Provider.of<DispensaryService>(context, listen: false);

    final createDispensary = await dispensaryService
        .deliveredDispensary(widget.dispensaryProducts.id);

    if (createDispensary != null) {
      if (createDispensary.ok) {
        subscriptionBloc.getSubscriptionsApprove(profile.user.uid);

        widget.productsDispensaryBloc.getDispensariesProducts(
            profile.user.uid, widget.profileUser.user.uid);

        this.socketService.emit('principal-notification',
            {'by': profile.user.uid, 'for': widget.profileUser.user.uid});

        Navigator.pop(context);
        _showSnackBar(context, 'Pedido Entregado y Notificado 👍');
      } else {
        mostrarAlerta(context, 'Error', createDispensary.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
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

class CbdthcRow extends StatelessWidget {
  const CbdthcRow(
      {Key key, @required this.thc, @required this.cbd, this.fontSize = 15})
      : super(key: key);

  final String thc;
  final String cbd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color(0xffF12937E),
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "THC: $thc %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "CBD: $cbd %",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
