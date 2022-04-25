import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'package:trans_money/banque/services/authservice.dart';

class Setting extends StatefulWidget {

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  Map<String, dynamic> user = new Map();
  Map<String, dynamic> user2 = new Map();
  Map<String, String> headers = new Map();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = '';
  String newpassword = '';
  String confirmpassword = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Enter password"),
                      controller: _password,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String value) {
                        if(value.length == 0) {
                          return "Entrer name";
                        }
                        return null;
                      },
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.lock),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Enter new password"),
                      controller: _newpassword,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if(value.length == 0) {
                          return "Entrer name";
                        }
                        return null;
                      },
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.lock),
                    title: TextFormField(
                     decoration: InputDecoration(hintText: "Confirm password"),
                     controller: _confirmpassword,
                     obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String value) {
                        if(value.length == 0) {
                          return "Entrer name";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(onPressed:(){updatepassword(_password,_newpassword,_confirmpassword);} ,color: Colors.red, child: Text("Modiffier"),),
                  )
                ],
              ),
            ),
      );
  }

void initState(){
    loadUser();
    super.initState();
  }

updatepassword(TextEditingController passwordf,TextEditingController newpasswordf,TextEditingController confpasswordf){
  var url = Uri.parse(GlobaleData.host+"/UpdatePassword/"+user['id'].toString());
  headers["Authorization"] = Authservice.token;
  setState(() {
    this.password = passwordf.text;
    this.newpassword = newpasswordf.text;
    this.confirmpassword = confpasswordf.text;
    final userform = json.encode({'password':this.password,
                                  'newpassword':this.newpassword,
                                  'confirmpassword':this.confirmpassword});
  if(this.password==''|| this.newpassword =='' || this.confirmpassword==''){
   DialogGood(context, "contenu des champt", "il y un champt vide");
  }

  if(this.password !='' && this.newpassword !='' && this.confirmpassword !=''){
      if(this.newpassword!= this.confirmpassword){
        DialogGood(context, "contenu des champt", "confirmer bien votre nouveau mot de passe");
      }

        if(this.newpassword==this.confirmpassword){
          http.post(url,body: userform, headers: {
            'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': Authservice.token
          }).then((resp){
          setState(() {
            this.user2 = json.decode(resp.body);
            DialogGood(context, "contenu des champt", "entre bien votre ancient mot de passe");
            print("resse goog passro");
          });
          }).catchError((err){
            DialogGood(context, "contenu des champt", "mot de passe modiffié avec succes");
          print("error password 4455555555555555555555 erororo");
        });

      }
  }
  });
}

void loadUser(){
    var url = Uri.parse(GlobaleData.host+"/findUser/"+Authservice.usernameauth);
    headers["Authorization"] = Authservice.token;
     http.get(url,headers: headers)
    .then((resp){
      setState((){
         this.user =json.decode(resp.body);
         print(Authservice.usernameauth);
      });
    }).catchError((err){
      print(err);
    });
  }

  static DialogGood(context,title,message) {
    return showDialog(context: context, builder:(BuildContext context){
    return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
});

}

}
