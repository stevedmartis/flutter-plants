import 'package:leafety/models/notification.dart';
import 'package:leafety/models/shoes.dart';
import 'package:leafety/pages/principal_page.dart';
import 'package:leafety/services/air_service.dart';
import 'package:leafety/services/aws_service.dart';
import 'package:leafety/services/catalogo_service.dart';
import 'package:leafety/services/dispensary_service.dart';
import 'package:leafety/services/light_service.dart';
import 'package:leafety/services/notification_service.dart';
import 'package:leafety/services/plant_services.dart';
import 'package:leafety/services/product_services.dart';
import 'package:leafety/services/room_services.dart';
import 'package:leafety/services/subscription_service.dart';
import 'package:leafety/services/visit_service.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:leafety/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:leafety/services/auth_service.dart';
import 'package:leafety/services/chat_service.dart';
import 'package:leafety/services/socket_service.dart';

import 'package:leafety/routes/routes.dart';

import 'bloc/provider.dart';
import 'package:flutter/services.dart';

import 'helpers/ui_overlay_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new AuthUserPreferences();
  await prefs.initPrefs();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthService()),
    ChangeNotifierProvider(create: (_) => SocketService()),
    ChangeNotifierProvider(create: (_) => RoomService()),
    ChangeNotifierProvider(create: (_) => ChatService()),
    ChangeNotifierProvider(create: (_) => ThemeChanger(3)),
    ChangeNotifierProvider(create: (_) => ShoesModel()),
    ChangeNotifierProvider(create: (_) => MenuModel()),
    ChangeNotifierProvider(create: (_) => AwsService()),
    ChangeNotifierProvider(create: (_) => PlantService()),
    ChangeNotifierProvider(create: (_) => AirService()),
    ChangeNotifierProvider(create: (_) => LightService()),
    ChangeNotifierProvider(create: (_) => VisitService()),
    ChangeNotifierProvider(create: (_) => SubscriptionService()),
    ChangeNotifierProvider(create: (_) => NotificationModel()),
    ChangeNotifierProvider(create: (_) => CatalogoService()),
    ChangeNotifierProvider(create: (_) => ProductService()),
    ChangeNotifierProvider(create: (_) => NotificationService()),
    ChangeNotifierProvider(create: (_) => DispensaryService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final currentTheme = Provider.of<ThemeChanger>(context);

    changeStatusLight();

    return CustomProvider(
      child: MaterialApp(
        theme: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        title: 'Leafety',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
