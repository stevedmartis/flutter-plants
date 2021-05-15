import 'package:leafety/helpers/ui_overlay_style.dart';
import 'package:leafety/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafety/services/auth_service.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final profile = authService.profile;

    changeStatusDark();

    return Scaffold(
      body: Center(
        child: MyProfile(
          profile: profile,
          isUserAuth: true,
          isUserEdit: true,
        ),
      ),
    );
  }
}
