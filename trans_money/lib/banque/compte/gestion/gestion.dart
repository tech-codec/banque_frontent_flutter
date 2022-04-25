import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'dart:convert';

import 'package:trans_money/banque/services/authservice.dart';


class Gestion extends StatefulWidget {

  @override
  State<Gestion> createState() => _GestionState();
}

class _GestionState extends State<Gestion> {

  // Group Value for Radio Button.
  int id = 0;
  String solde;
  int valec = 0;
  int valee = 0;
  Map<String, String> headers = new Map();
  Map<String, String> PDF = new Map();

  Map<String, dynamic> user = new Map();
  Map<String, dynamic> compte = new Map();
  final TextEditingController _solde = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Container(height: 30,),
            this.valec==1?Column(
              children: [
              Text(
                'Créer compte Courant',
                style: new TextStyle(fontSize: 17.0),
              ),
               Radio(
                value: 1,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 1;
                  });
                },
              ),

              id==1?new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _solde,
                style: textStyle(),
                onChanged: (value){
                  debugPrint("la valeur du titre");

                },
                decoration:new InputDecoration(
                  labelText: 'Entrer un montant',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )):Container(),
              id==1?Padding(
                 padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:new Text("valider",style: textStyle(),),
                        onPressed: (){
                          print("pas mal");
                          addcompteCourent(_solde);
                        }),
               ):Container(),
              ],
            ):Container(),

            this.valee==1?Column(
              children: [
              Text(
                'Créer compte Epargne',
                style: new TextStyle(fontSize: 17.0),
              ),
               Radio(
                value: 2,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 2;
                  });
                },
              ),

              id==2?new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _solde,
                style: textStyle(),
                onChanged: (value){
                  debugPrint("la valeur du titre");

                },
                decoration:new InputDecoration(
                  labelText: 'Entrer un montant',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )):Container(),
              id==2?Padding(
                 padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:new Text("valider",style: textStyle(),),
                        onPressed: (){
                          print("pas mal");
                          addcompteEpargne(_solde);
                        }),
               ):Container(),
              ],
            ):Container(),
            this.valec==2?Container(
              color: Colors.redAccent,
              height: 200,
              child: Column(children: [
                Text("Code compte: "+this.compte['_embedded']['compteCourants'][0]['codeCp'].toString(),style: textStyle()),
                Text("montant: "+this.compte['_embedded']['compteCourants'][0]['solde'].toString(),style: textStyle()),
                Text("Type: Compte Courent",style: textStyle()),
                Text("Date création: "+this.compte['_embedded']['compteCourants'][0]['dateCreationCp'].toString(),style: textStyle()),
              ],),
            ):Container(),

            this.valee==2?Container(
              color: Colors.redAccent,
              height: 200,
              child: Column(children: [
                Text("Code compte: "+this.compte['_embedded']['compteEpargnes'][0]['codeCp'].toString(),style: textStyle()),
                Text("montant: "+this.compte['_embedded']['compteEpargnes'][0]['solde'].toString(),style: textStyle()),
                Text("Type: Compte Epargne",style: textStyle()),
                Text("Date création: "+this.compte['_embedded']['compteEpargnes'][0]['dateCreationCp'].toString(),style: textStyle()),
              ],),
            ):Container(),

          ],
        ),
      ),
    );
  }

void initState(){
    loadUser();
    super.initState();
  }

TextStyle textStyle(){
  return TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black
  );
}

void loadUser(){
    var url = Uri.parse(GlobaleData.host+"/findUser/"+Authservice.usernameauth);
    headers["Authorization"] = Authservice.token;
     http.get(url,headers: headers)
    .then((resp){
      setState((){
         this.user =json.decode(resp.body);
         getComptes();
         print(Authservice.usernameauth);
      });
    }).catchError((err){
      print(err);
    });
  }

  void getComptes(){
    var url = Uri.parse(GlobaleData.host+"/users/"+this.user['id'].toString()+"/comptes");
    headers["Authorization"] = Authservice.token;
    http.get(url,headers: headers).then((resp){
      setState(() {
        this.compte = json.decode(resp.body);
        if(this.compte['_embedded']['compteCourants']==null){
          print(this.compte['_embedded']['compteCourants']);
          this.valec = 1;
        }
        if(this.compte['_embedded']['compteEpargnes']==null){
          print(this.compte['_embedded']['compteCourants']);
          this.valee = 1;
        }
        if(this.compte['_embedded']['compteCourants']!=null){
          print(this.compte['_embedded']['compteCourants']);
          this.valec = 2;
        }
        if(this.compte['_embedded']['compteEpargnes']!=null){
          print(this.compte['_embedded']['compteCourants']);
        }
      });
    }).catchError((err){
      print("error de compte 125");
      //print(this.user['id']);
    });
  }

  pdfEpargne(){
      var url = Uri.parse(GlobaleData.host+"/pdfCompte/"+this.compte['_embedded']['compteEpargnes'][0]['codeCp'].toString());
      headers["Authorization"] = Authservice.token;
      if(this.compte['_embedded']['compteEpargnes']!=null){
          http.get(url,headers: headers).then((resp){
          print("fiche impprimer avec succes");
          print(resp.body);
        }).catchError((err){
          print("imprimer error fiche");
        });
      }
  }

addcompteCourent(TextEditingController soldef){
   var url = Uri.parse(GlobaleData.host+"/addCompteCourantToUser/"+this.user['id'].toString());
    headers["Authorization"] = Authservice.token;
    setState(() {
      this.solde = soldef.text;
      final soldeform = json.encode({"solde":this.solde});
      http.post(url,body: soldeform, headers: {
         'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Authservice.token
      }).then((resp){
        print("compte cree avec succes");
        DialogGood(context, "creation du compte courent", "création de compte avec succes");
      }).catchError((err){
        print("compte erro creer");
         DialogGood(context, "creation du compte courent", "erreur de création du compte courent");
      });
    });

}

addcompteEpargne(TextEditingController soldef){
   var url = Uri.parse(GlobaleData.host+"/addCompteEpargneToUser/"+this.user['id'].toString());
    headers["Authorization"] = Authservice.token;
    setState(() {
      this.solde = soldef.text;
      final soldeform =json.encode({"solde":this.solde});
      http.post(url,body: soldeform, headers: {
         'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Authservice.token
      }).then((resp){
        print("compte cree avec succes");
        DialogGood(context, "creation du compte Epargne", "création de compte avec succes");
        this.valee=2;
      }).catchError((err){
        print("compte erro creer");
         DialogGood(context, "creation du compte epargne", "erreur de création du compte epargne");
      });
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
