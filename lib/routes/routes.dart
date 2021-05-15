import 'package:leafety/pages/messages.dart';
import 'package:leafety/pages/my_profile.dart';
import 'package:leafety/pages/notification_page.dart';
import 'package:leafety/pages/onBoarding_page.dart';
import 'package:leafety/pages/principalCustom_page.dart';
import 'package:leafety/pages/catalogs_list_page.dart';
import 'package:leafety/pages/profile_edit.dart';
import 'package:leafety/pages/profile_page.dart';
import 'package:leafety/pages/room_list_page.dart';
import 'package:leafety/pages/subscriptors_page.dart';
import 'package:leafety/pages/tabs.dart';
import 'package:leafety/pages/user_page.dart';
import 'package:flutter/material.dart';

import 'package:leafety/pages/chat_page.dart';
import 'package:leafety/pages/loading_page.dart';
import 'package:leafety/pages/login_page.dart';
import 'package:leafety/pages/register_page.dart';
import 'package:leafety/pages/principal_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => LoadingPage(),
  'onboard': (_) => OnBoardingScreen(),
  'register': (_) => RegisterPage(),
  'login': (_) => LoginPage(),
  'principal': (_) => PrincipalPage(),
  'profile': (_) => SliverAppBarProfilepPage(),
  'profile_auth': (_) => UserPage(),
  'profile_edit': (_) => MyProfilePage(),
  'rooms': (_) => RoomsListPage(),
  'chat': (_) => ChatPage(),
  'tabs': (_) => TabsCustom(),
  '/profile-edit': (_) => EditProfilePage(),
};

final pageRouter = <_Route>[
  _Route(FontAwesomeIcons.home, 'principal', CollapsingList()),
  _Route(FontAwesomeIcons.comments, 'subscriptors', SubscriptorsPage()),
  _Route(FontAwesomeIcons.home, 'rooms', RoomsListPage()),
  _Route(FontAwesomeIcons.home, 'catalogos', CatalogosListPage()),
  _Route(FontAwesomeIcons.comments, 'notifications', NotificationsPage()),
  _Route(FontAwesomeIcons.comments, 'messages', MessagesPage()),
  _Route(FontAwesomeIcons.user, 'profile', SliverAppBarProfilepPage()),
  _Route(FontAwesomeIcons.democrat, 'onboard', OnBoardingScreen()),
  _Route(FontAwesomeIcons.user, 'profile_auth', UserPage()),
  _Route(FontAwesomeIcons.truckLoading, 'loading', LoadingPage()),
  _Route(FontAwesomeIcons.sign, 'register', RegisterPage()),
  _Route(FontAwesomeIcons.signInAlt, 'login', LoginPage()),
  _Route(FontAwesomeIcons.signInAlt, 'profile_edit', MyProfilePage()),
  _Route(FontAwesomeIcons.signInAlt, 'chat', ChatPage()),
  _Route(FontAwesomeIcons.signInAlt, 'tabs', TabsCustom()),
  _Route(FontAwesomeIcons.signInAlt, 'profile-edit', EditProfilePage()),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;

  _Route(this.icon, this.title, this.page);
}
