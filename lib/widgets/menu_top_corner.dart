import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';


class MenuButton extends StatelessWidget {
  const MenuButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(OMIcons.menu),
      onPressed: (){
        Drawer(
        );
      },

    );
  }
}
