import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/services/socket_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:flutter_plants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrincipalMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final accentColor = appTheme.currentTheme.accentColor;
    final prefs = new AuthUserPreferences();

    final size = MediaQuery.of(context).size;

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);
    final currentTheme = Provider.of<ThemeChanger>(context);
    final profile = authService.profile;

    return SafeArea(
      child: Container(
        width: size.width / 1.5,
        child: Drawer(
          child: Container(
            color: currentTheme.currentTheme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    profile.user.username,
                    style: TextStyle(
                      fontSize: 20,
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    socketService.disconnect();

                    Navigator.pushNamedAndRemoveUntil(
                        context, "login", (Route<dynamic> route) => false);

                    prefs.setToken = '';
                    AuthService.signOut();
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: accentColor),
                    title: Text(
                      'Sign off',
                      style: TextStyle(
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
