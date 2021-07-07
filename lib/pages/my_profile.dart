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
    Size _size = MediaQuery.of(context).size;

    changeStatusDark();

    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      return AnimatedContainer(
        padding: constraints.maxWidth < 500 ? EdgeInsets.zero : EdgeInsets.zero,
        duration: Duration(milliseconds: 500),

        child: Container(
          constraints: BoxConstraints(maxWidth: 500, minWidth: 500),
          width: _size.width,
          height: _size.height,
          child: Center(
            child: MyProfile(
              profile: profile,
              isUserAuth: true,
              isUserEdit: true,
            ),
          ),
        ),

        //CollapsingList(_hideBottomNavController),

        // floatingActionButton: ButtomFloating(),
      );
    })));
  }
}
