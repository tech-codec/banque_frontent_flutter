import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trans_money/banque/accueil.dart';
import 'dart:convert';
import 'dart:async';

import 'package:trans_money/banque/banqueconfig/globalevariable.dart';

class Authservice{
  static String token ='';
  static String usernameauth = '';
  static void login(String username, String password,_context) async{
    var reponse ;
    var url = Uri.parse(GlobaleData.host+"/login");
    final userData= jsonEncode(
        {
          "username":username,
          "password":password
        }
      );
    await http.post(url, body: userData,headers: {
       'Content-type': 'application/json',
        'Accept': 'application/json'
        }
      ).then((resp){
        if(resp.headers['authorization']!=null){
          reponse= resp.headers['authorization'];
          Authservice.token = reponse;
          Authservice.usernameauth = username;
          Navigator.of(_context).push(MaterialPageRoute(builder:(context)=>new BanqueApp(username,password,Authservice.token)));
          print(reponse);
        }else{
          Authservice.getAlertDialog(_context,"Login failed",'password or userName is incorrect');
        }
    }).catchError((err){
      Authservice.getAlertDialog(_context,"Login failed",'password or userName is incorrect');
    });
  }

  static void register(String email, String username, String password, String repeatPassword, _context) async{
    var reponse ;
    var url = Uri.parse(GlobaleData.host+"/userRegister");
    final userData= jsonEncode(
        {
          "username":username,
          "email":email,
          "password":password,
          "repassword":repeatPassword
        }
      );
    await http.post(url, body: userData,headers: {
       'Content-type': 'application/json',
        'Accept': 'application/json'
        }
      ).then((resp){
        reponse= json.decode(resp.body);
        if(password!=repeatPassword || password==null|| email==null ||
            repeatPassword==null || username==null || !email.contains('@')||
            password.isEmpty || email.isEmpty || repeatPassword.isEmpty || username.isEmpty){
          Authservice.registerDialogBad(_context,"bad register",
          '- vous avez mal confirmer votre mot de passe!!'+' \n'+
          '- ou votre addresse est incorrecte!! ' + '\n' +
          '- ou vous avez laisser un champ vide '
          );
        }
    }).catchError((err){
      Authservice.registerDialogGood(_context,"confirmer",'une adresse vous a ete envoyer sur ${email} pour activer votre compte!!');
    });
  }


  static void ressetPassword(String email,_context) async{
    var reponse ;
    var url = Uri.parse(GlobaleData.host+"/request");
    final userData= jsonEncode(
        {
          "email":email,
        }
      );
    await http.post(url, body: userData,headers: {
       'Content-type': 'application/json',
        'Accept': 'application/json'
        }
      ).then((resp){
        if(!email.contains('@') || email==null || email.isEmpty){
          Authservice.getAlertDialog(_context, "renitialisation faile", "votre adresse est incorecte"+'\n'+
          "ou le champ est vide");
        }
        Authservice.registerDialogGood(_context,"reset password","une email vous as été envoyer a l'adresse: "+email);
    }).catchError((err){
      Authservice.registerDialogGood(_context,"reset password erro","une email vous as été envoyer a l'adresse: "+email);
    });
  }

  static getAlertDialog(context,title,message) {
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




static registerDialogGood(context,title,message) {
    return showDialog(context: context, builder:(BuildContext context){
    return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    ],
  );
});

}

static registerDialogBad(context,title,message) {
    return showDialog(context: context, builder:(BuildContext context){
    return AlertDialog(
    title: Text("${title}"),
    content: Text('${message}'),
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
