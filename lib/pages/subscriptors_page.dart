import 'package:animate_do/animate_do.dart';
import 'package:flutter_plants/bloc/subscribe_bloc.dart';
import 'package:flutter_plants/models/profile_dispensary.dart';
import 'package:flutter_plants/models/profiles.dart';
import 'package:flutter_plants/models/profilesDispensaries_response.dart';
import 'package:flutter_plants/pages/principalCustom_page.dart';
import 'package:flutter_plants/pages/recipe_image_page.dart';
import 'package:flutter_plants/providers/notifications_provider.dart';
import 'package:flutter_plants/providers/subscription_provider.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/services/chat_service.dart';
import 'package:flutter_plants/services/socket_service.dart';
import 'package:flutter_plants/theme/theme.dart';
import 'package:flutter_plants/widgets/avatar_user_chat.dart';
import 'package:flutter_plants/widgets/chat_message.dart';
import 'package:flutter_plants/widgets/header_appbar_pages.dart';
import 'package:flutter_plants/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class SubscriptorsPage extends StatefulWidget {
  SubscriptorsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SubscriptorsPageState createState() => _SubscriptorsPageState();
}

class _SubscriptorsPageState extends State<SubscriptorsPage>
    with TickerProviderStateMixin {
  final notificationsProvider = new NotificationsProvider();

  final subscriptionApiProvider = new SubscriptionApiProvider();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  Profiles profile;
  List<ChatMessage> _messages = [];
  List<ProfileDispensary> profiles = [];
  SlidableController slidableController;

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
    this.socketService.socket.on('personal-message', _listenMessage);

    subscriptionBloc.getSubscriptionsApprove(profile.user.uid);

    super.initState();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload['message'],
      uid: payload['by'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
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
              makeHeaderCustom((profile.isClub) ? 'Miembros' : 'Mis Clubs'),
              makeListNotifications(context)
            ]),
        // bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
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
                        title: title, action: Container())))));
  }

  Widget _buildList(BuildContext context, Axis direction) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder<ProfilesDispensariesResponse>(
      stream: subscriptionBloc.subscriptionsApprove.stream,
      builder: (context, AsyncSnapshot<ProfilesDispensariesResponse> snapshot) {
        if (snapshot.hasData) {
          profiles = snapshot.data.profilesDispensaries;

          if (profiles.length > 0) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: profiles.length,
              itemBuilder: (BuildContext ctxt, int index) {
                var item = profiles[index];

                final DateTime dateMessage = item.profile.messageDate;

                final DateTime dateDelivered = item.dispensary.updatedAt;

                final DateFormat formatter = DateFormat('dd MMM - kk:mm a');
                final String formatted = formatter.format(dateMessage);

                final DateFormat formatterDispensary =
                    DateFormat('dd MMM - kk:mm');
                final String dateDeliveredFormatter =
                    formatterDispensary.format(dateDelivered);
                final nameSub = (item.profile.name == "")
                    ? item.profile.user.username
                    : item.profile.name;

                // final gramsRecipe = item.dispensary.gramsRecipe;
                return Column(
                  children: [
                    //final int t = index;
                    FadeInLeft(
                      delay: Duration(milliseconds: 300 * index),
                      child: Slidable.builder(
                        key: Key(item.profile.id),
                        controller: slidableController,
                        direction: Axis.horizontal,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Text(nameSub,
                                        style: TextStyle(
                                            color: (currentTheme.customTheme)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18)),
                                  ),
                                  /* if (item.dispensary.isActive &&
                                      item.dispensary.isDelivered)
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 0),
                                          child: Text(
                                            'Recetados:',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 0),
                                          child: Text(
                                            '$gramsRecipe',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ) */
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!item.dispensary.isActive &&
                                      !item.dispensary.isDelivered)
                                    Container(
                                      child: Text(
                                        'Aprobado: $formatted',
                                        style: TextStyle(
                                            color: (currentTheme.customTheme)
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
                                              backgroundColor: currentTheme
                                                  .currentTheme
                                                  .scaffoldBackgroundColor,
                                              child: Icon(Icons.pending)),
                                          label: Text('En Curso'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            '$dateDeliveredFormatter',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (item.dispensary.isActive &&
                                      item.dispensary.isDelivered)
                                    Row(
                                      children: [
                                        Chip(
                                          backgroundColor: currentTheme
                                              .currentTheme.accentColor,
                                          avatar: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.check,
                                                color: currentTheme
                                                    .currentTheme.accentColor,
                                              )),
                                          label: Text(
                                            'Entregado',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            '$dateDeliveredFormatter',
                                            style: TextStyle(
                                                color:
                                                    (currentTheme.customTheme)
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              trailing: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: currentTheme.currentTheme.accentColor,
                                  size: 30,
                                ),
                              ),
                              onTap: () {
                                final chatService = Provider.of<ChatService>(
                                    context,
                                    listen: false);
                                chatService.userFor = item.profile;

                                Navigator.of(context).push(
                                    createRouteProfileSelect(item.profile));
                              },
                            ),
                          ),
                        ),
                        secondaryActionDelegate: SlideActionBuilderDelegate(
                            actionCount: 1,
                            builder:
                                (context, index, animation, renderingMode) {
                              return IconSlideAction(
                                caption: 'Eliminar',
                                color: renderingMode ==
                                        SlidableRenderingMode.slide
                                    ? Colors.red.withOpacity(animation.value)
                                    : Colors.red,
                                icon: Icons.delete,
                                onTap: () async {
                                  var state = Slidable.of(context);
                                  var dismiss = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            currentTheme.currentTheme.cardColor,
                                        title: Text(
                                          'Eliminar Suscripción',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        content: Text(
                                          (profile.isClub)
                                              ? 'Se anulara la suscripción de este miembro'
                                              : 'Se anulara tu suscripción a club',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Eliminar',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () =>
                                                _deleteSubscription(
                                                    item.profile.subId, index),
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
                    ),
                  ],
                );
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

  _deleteSubscription(String id, int index) async {
    final res = await this.subscriptionApiProvider.disapproveSubscription(id);
    if (res) {
      setState(() {
        subscriptionBloc.getSubscriptionsApprove(profile.user.uid);

        Navigator.of(context).pop(true);
      });
    }
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

  Route createRouteProfileSelect(Profiles profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyProfile(
        title: '',
        profile: profile,
        isUserAuth: false,
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
        height: 400.0, child: Center(child: CircularProgressIndicator()));
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
}
