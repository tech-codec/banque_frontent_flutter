import 'package:flutter/material.dart';
import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'package:trans_money/banque/compte/gestion/gestion.dart';
import 'package:trans_money/banque/compte/operation/operation.dart';
import 'package:trans_money/banque/compte/setting/setting.dart';
import 'package:trans_money/banque/profile/profile-page.dart';
import 'package:trans_money/banque/services/authservice.dart';

import 'menu-irem.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class BanqueApp extends StatefulWidget {

  String username;
  String password;
  String token;
  BanqueApp(this.username,this.password,this.token);

  @override
  State<BanqueApp> createState() => _BanqueAppState();
}

class _BanqueAppState extends State<BanqueApp> with SingleTickerProviderStateMixin {

  int idclient;
  Map<String, String> headers = new Map();

  Map<String, dynamic> user = new Map();

  final menus = [
    {'title': 'Profile', 'icon': Icon(Icons.portrait),'page':0},
    {'title': 'Opération', 'icon': Icon(Icons.money),'page':1},
    {'title': 'Gestion', 'icon': Icon(Icons.crop_portrait),'page':2},
    {'title': 'Setting', 'icon': Icon(Icons.settings),'page':3},
  ];

  TabController controller;


  void initState(){
    controller = new TabController(vsync: this, length:4);
    loadUser();
    super.initState();
  }


  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
          title:new Text('TransMoney',
          style:new TextStyle(fontSize: 25.5,fontWeight: FontWeight.bold),),
          bottom: tapbar(controller),
        ),
      body: Center(
        child: tabbarView(controller),
        ),
        drawer: Drawer(
          child:ListView(
            children: [
               DrawerHeader(
              decoration: BoxDecoration(
               color: Colors.redAccent,
             ),
              child: Padding(padding: EdgeInsets.all(6),
              child:new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 70,
                    height: 70,
                    child: Center(
                      child: CircleAvatar(
                        maxRadius: 50,
                        child:this.user['photo']==null?Text("vous avez pas de photo"):Image.network(GlobaleData.host +"/userImage/${this.user["id"]}",headers:{'Authservice.token':Authservice.token} ,),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("Nom: "+user["username"].toString(),
                  style:new TextStyle(fontSize: 15,fontStyle: FontStyle.italic
                  ,fontWeight: FontWeight.bold,color: Colors.white),),
                  SizedBox(height: 3,),
                  Text("Email: "+user["email"].toString(),
                  style:new TextStyle(fontSize: 15,fontStyle: FontStyle.italic
                  ,fontWeight: FontWeight.bold,color: Colors.white),),
                ],
              ),),


            ),
              ...this.menus.map((item){
                return new Column(
                  children:<Widget> [
                     Divider(color: Colors.orange,),
                     MenuItem(item['title'].toString(), item['icon'] as Icon, (context){
                        Navigator.pop(context);
                        controller.index = item['page'];
                      })
                  ],
                );
              }),
            ],) ,
          ),
    );
  }

   void loadUser(){
    var url = Uri.parse(GlobaleData.host+"/findUser/"+widget.username);
    headers["Authorization"] = Authservice.token;
     http.get(url,headers: headers)
    .then((resp){
      setState((){
         this.user =json.decode(resp.body);
         //print(user);
      });
    }).catchError((err){
      print(err);
    });
  }

  Widget tapbar(controller){
  return new TabBar(
    controller: controller,
    tabs: <Widget>[
      new Tab(icon: new Icon(Icons.portrait),text: 'Profile'),
      new Tab(icon: new Icon(Icons.money),text: 'Opération'),
      new Tab(icon: new Icon(Icons.crop_portrait),text: 'Géstion'),
      new Tab(icon: new Icon(Icons.settings),text: 'Setting'),
    ],
  );
}


Widget tabbarView(controller){
  return new TabBarView(
    controller: controller,
    children: <Widget>[
      new Profile(widget.username),
      new Operation(),
      new Gestion(),
      new Setting()
    ]);

}


}


