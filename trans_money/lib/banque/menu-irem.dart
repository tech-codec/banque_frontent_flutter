import 'package:flutter/material.dart';
class MenuItem extends StatelessWidget {
  String menuTitle;
  Icon menuIcon;
  Function handler;
  MenuItem(this.menuTitle, this.menuIcon,this.handler);
  @override
  Widget build(BuildContext context) {
    return ListTile(
                title: Text(menuTitle) ,
                leading: menuIcon,
                trailing:Icon(Icons.arrow_right),
                onTap: (){
                  this.handler(context);
                },
          );
  }
}
