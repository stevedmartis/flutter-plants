import 'package:leafety/bloc/dispensary_bloc.dart';
import 'package:leafety/bloc/subscribe_bloc.dart';
import 'package:leafety/models/dispensaries_products_response%20copy.dart';
import 'package:leafety/models/profile_dispensary.dart';
import 'package:leafety/models/profiles.dart';
import 'package:leafety/models/profilesDispensaries_response.dart';
import 'package:leafety/pages/principalCustom_page.dart';
import 'package:leafety/pages/recipe_image_page.dart';
import 'package:leafety/providers/notifications_provider.dart';
import 'package:leafety/providers/subscription_provider.dart';
import 'package:leafety/services/auth_service.dart';
import 'package:leafety/services/chat_service.dart';
import 'package:leafety/services/socket_service.dart';
import 'package:leafety/theme/theme.dart';
import 'package:leafety/widgets/avatar_user_chat.dart';
import 'package:leafety/widgets/carousel_users.dart';
import 'package:leafety/widgets/header_appbar_pages.dart';
import 'package:leafety/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'dispensar_products.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  final notificationsProvider = new NotificationsProvider();

  final subscriptionApiProvider = new SubscriptionApiProvider();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  Profiles profile;
  List<ProfileDispensary> profiles = [];
  SlidableController slidableController;

  final List<_HomeItem> items = List.generate(
    20,
    (i) => _HomeItem(
      i,
      'Tile n°$i',
      _getSubtitle(i),
      _getAvatarColor(i),
    ),
  );

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    profile = authService.profile;
    //this.socketService.socket.on('personal-message', _listenMessage);

    subscriptionBloc.getSubscriptionsPending(profile.user.uid);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Animation<double> rotationAnimation;
  Color fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              makeHeaderCustom('Notificaciones'),
              makeListNotifications(context)
            ]),
      ),
    );
  }

  SliverList makeListNotifications(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildList(
          context,
          Axis.vertical,
        ),
      ),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                        title: title,
                        action:
                            // Container()

                            Container())))));
  }

  Widget _buildList(BuildContext context, Axis direction) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder<ProfilesDispensariesResponse>(
      stream: subscriptionBloc.subscriptionsPending.stream,
      builder: (context, AsyncSnapshot<ProfilesDispensariesResponse> snapshot) {
        if (snapshot.hasData) {
          profiles = snapshot.data.profilesDispensaries;

          if (profiles.length > 0) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: profiles.length,
              itemBuilder: (BuildContext ctxt, int index) {
                ProfileDispensary item = profiles[index];

                final DateTime dateMessage = item.profile.messageDate;

                final DateFormat formatter = DateFormat('dd MMM - kk:mm a');
                final String formatted = formatter.format(dateMessage);
                final nameSub = (item.profile.name == "")
                    ? item.profile.user.username
                    : item.profile.name;

                final DateTime dateDelivered = item.dispensary.updatedAt;

                final DateFormat formatterDispensary =
                    DateFormat('dd MMM - kk:mm');
                final String dateDeliveredFormatter =
                    formatterDispensary.format(dateDelivered);

                return (profile.isClub)
                    ? Container(
                        child: Column(
                          children: [
                            //final int t = index;
                            Slidable.builder(
                              key: Key(item.profile.id),
                              controller: slidableController,
                              direction: Axis.horizontal,
                              dismissal: SlidableDismissal(
                                child: SlidableDrawerDismissal(),
                                onDismissed: (actionType) => {
                                  _showSnackBar(
                                      context,
                                      actionType == SlideActionType.primary
                                          ? 'Aprobado!, se agrego en "Miembros"'
                                          : 'Suscripción anulada.'),
                                  setState(() {
                                    profiles.removeAt(index);
                                  }),
                                  actionType == SlideActionType.primary
                                      ? _approveSubscription(
                                          item.profile, index)
                                      : _deleteSubscription(
                                          item.profile.subId, index),
                                },
                              ),
                              actionPane: _getActionPane(index),
                              actionExtentRatio: 0.25,
                              child: InkWell(
                                onTap: () {},
                                child: Material(
                                  child: ListTile(
                                    tileColor: (currentTheme.customTheme)
                                        ? currentTheme.currentTheme.cardColor
                                        : Colors.white,
                                    leading: ImageUserChat(
                                        width: 100,
                                        height: 100,
                                        profile: item.profile,
                                        fontsize: 20),
                                    title: Text(nameSub,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: (currentTheme.customTheme)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18)),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            'Solicitud: $formatted',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Aprobación pendiente.',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: currentTheme
                                            .currentTheme.accentColor,
                                        size: 30,
                                      ),
                                    ),
                                    onTap: () {
                                      final chatService =
                                          Provider.of<ChatService>(context,
                                              listen: false);
                                      chatService.userFor = item.profile;
                                      Navigator.of(context).push(
                                          createRouteProfileSelect(
                                              item.profile));
                                    },
                                  ),
                                ),
                              ),
                              actionDelegate: SlideActionBuilderDelegate(
                                  actionCount: 1,
                                  builder: (context, index, animation,
                                      renderingMode) {
                                    return IconSlideAction(
                                      caption: 'Aprobar',
                                      color: renderingMode ==
                                              SlidableRenderingMode.slide
                                          ? Colors.blue
                                              .withOpacity(animation.value)
                                          : (renderingMode ==
                                                  SlidableRenderingMode.dismiss
                                              ? Colors.blue
                                              : currentTheme
                                                  .currentTheme.accentColor),
                                      icon: Icons.check_circle,
                                      onTap: () async {
                                        var state = Slidable.of(context);
                                        state.dismiss();
                                      },
                                    );
                                  }),
                              secondaryActionDelegate:
                                  SlideActionBuilderDelegate(
                                      actionCount: 1,
                                      builder: (context, index, animation,
                                          renderingMode) {
                                        return IconSlideAction(
                                          caption: 'Eliminar',
                                          color: renderingMode ==
                                                  SlidableRenderingMode.slide
                                              ? Colors.red
                                                  .withOpacity(animation.value)
                                              : Colors.red,
                                          icon: Icons.delete,
                                          onTap: () async {
                                            var state = Slidable.of(context);
                                            var dismiss =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.black,
                                                  title: Text(
                                                    'Eliminar Solicitud',
                                                    style: TextStyle(
                                                        color: Colors.white54),
                                                  ),
                                                  content: Text(
                                                    'Se desaprobara la solicitud',
                                                    style: TextStyle(
                                                        color: Colors.white54),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (dismiss) {
                                              state.dismiss();
                                            }
                                          },
                                        );
                                      }),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                        children: [
                          //final int t = index;
                          Slidable.builder(
                            key: Key(item.profile.id),
                            controller: slidableController,
                            direction: Axis.horizontal,
                            dismissal: SlidableDismissal(
                              child: SlidableDrawerDismissal(),
                            ),
                            actionPane: _getActionPane(index),
                            actionExtentRatio: 0.25,
                            child: InkWell(
                              onTap: () {},
                              child: Material(
                                child: ListTile(
                                  tileColor: (currentTheme.customTheme)
                                      ? currentTheme.currentTheme.cardColor
                                      : Colors.white,
                                  leading: ImageUserChat(
                                      width: 100,
                                      height: 100,
                                      profile: item.profile,
                                      fontsize: 20),
                                  title: Row(
                                    children: [
                                      Text(nameSub,
                                          style: TextStyle(
                                              color: (currentTheme.customTheme)
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 18)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      if (item.dispensary.isActive &&
                                          !item.dispensary.isEdit &&
                                          !item.dispensary.isDelivered)
                                        Text('Pedido Creado!',
                                            style: TextStyle(
                                                color: currentTheme
                                                    .currentTheme.accentColor,
                                                fontSize: 15)),
                                      if (item.dispensary.isActive &&
                                          item.dispensary.isEdit &&
                                          !item.dispensary.isDelivered)
                                        Text('Pedido Editado',
                                            style: TextStyle(
                                                color: currentTheme
                                                    .currentTheme.accentColor,
                                                fontSize: 15)),
                                      if (!item.dispensary.isActive)
                                        Container(
                                          child: Text(
                                            'Aprobado!',
                                            style: TextStyle(
                                                color: currentTheme
                                                    .currentTheme.accentColor,
                                                fontSize: 15),
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: (!item.dispensary.isActive)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                '$formatted',
                                                style: TextStyle(
                                                    color: (currentTheme
                                                            .customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (!item.dispensary.isActive &&
                                                  !item.dispensary.isDelivered)
                                                Container(
                                                  child: Text(
                                                    'Aprobado: $formatted',
                                                    style: TextStyle(
                                                        color: (currentTheme
                                                                .customTheme)
                                                            ? Colors.white54
                                                            : Colors.black54,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              if (item.dispensary.isActive &&
                                                  !item.dispensary.isDelivered)
                                                Row(
                                                  children: [
                                                    Chip(
                                                      avatar: CircleAvatar(
                                                          backgroundColor:
                                                              currentTheme
                                                                  .currentTheme
                                                                  .scaffoldBackgroundColor,
                                                          child: Icon(
                                                              Icons.pending)),
                                                      label: Text('En Curso'),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '$dateDeliveredFormatter',
                                                        style: TextStyle(
                                                            color: (currentTheme
                                                                    .customTheme)
                                                                ? Colors.white54
                                                                : Colors
                                                                    .black54,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (item.dispensary.isActive &&
                                                  item.dispensary.isDelivered)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Chip(
                                                        backgroundColor:
                                                            currentTheme
                                                                .currentTheme
                                                                .accentColor,
                                                        avatar: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black,
                                                            child: Icon(
                                                              Icons.check,
                                                              color: currentTheme
                                                                  .currentTheme
                                                                  .accentColor,
                                                            )),
                                                        label: Text(
                                                          'Entregado',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '$dateDeliveredFormatter',
                                                        style: TextStyle(
                                                            color: (currentTheme
                                                                    .customTheme)
                                                                ? Colors.white54
                                                                : Colors
                                                                    .black54,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                  trailing: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color:
                                          currentTheme.currentTheme.accentColor,
                                      size: 30,
                                    ),
                                  ),
                                  onTap: () {
                                    final chatService =
                                        Provider.of<ChatService>(context,
                                            listen: false);
                                    chatService.userFor = item.profile;

                                    (!item.dispensary.isActive)
                                        ? Navigator.of(context).push(
                                            createRouteProfile(
                                                item.profile, false))
                                        : Navigator.of(context).push(
                                            createRouteProfile(profile, true));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
              },
            );
          } else {
            return _buildEmptyWidget();
          }
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Route createRouteProfile(Profiles profile, bool isAuth) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyProfile(
        title: '',
        profile: profile,
        isUserAuth: isAuth,
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

  Widget _buildEmptyWidget() {
    return Container(
        height: 400.0,
        child: Center(
            child: Text(
          'Vacio',
          style: TextStyle(color: Colors.grey),
        )));
  }

  _deleteSubscription(String id, int index) async {
    final res = await this.subscriptionApiProvider.disapproveSubscription(id);
    if (res) {
      setState(() {
        subscriptionBloc.getSubscriptionsPending(profile.user.uid);
      });
    }
  }

  _approveSubscription(Profiles item, int index) async {
    final res =
        await this.subscriptionApiProvider.approveSubscription(item.subId);
    if (res) {
      subscriptionBloc.getSubscriptionsPending(profile.user.uid);

      this.socketService.emit('principal-notification',
          {'by': profile.user.uid, 'for': item.user.uid});
    }
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

  Widget _buildLoadingWidget() {
    return Container(
        padding: EdgeInsets.all(10),
        height: 200.0,
        child: Center(child: CircularProgressIndicator()));
  }

  Route createRoutedispensary(
      Profiles item,
      DispensariesProduct dispensaryProducts,
      ProductDispensaryBloc productsDispensaryBloc) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DispensarProductPage(
              profileUser: profile,
              dispensaryProducts: dispensaryProducts,
              productsDispensaryBloc: productsDispensaryBloc),
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

  Route createRouteRecipeViewImage(Profiles item) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RecipeImagePage(profile: item),
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

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  static Color _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  static String _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindActionPane';
      case 1:
        return 'SlidableStrechActionPane';
      case 2:
        return 'SlidableScrollActionPane';
      case 3:
        return 'SlidableDrawerActionPane';
      default:
        return null;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor:
            (currentTheme.customTheme) ? Colors.white : Colors.black,
        content: Text(text,
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.black : Colors.white,
            ))));
  }
}

class _HomeItem {
  const _HomeItem(
    this.index,
    this.title,
    this.subtitle,
    this.color,
  );

  final int index;
  final String title;
  final String subtitle;
  final Color color;
}
