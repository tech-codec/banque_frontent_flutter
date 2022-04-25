import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'package:trans_money/banque/services/authservice.dart';


class TypeOperation extends StatefulWidget {

String codew;
  TypeOperation(this.codew);
  @override
  State<TypeOperation> createState() => _TypeOperationState();
}

class _TypeOperationState extends State<TypeOperation> {

  // Group Value for Radio Button.
  int id = 1;

  String codev = '';
  String montant;
  Map<String, String> headers = new Map();
  String nameop = 'versement';
  final TextEditingController _montant = TextEditingController();
  final TextEditingController _codev = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: Text("Type Opération",style: textStyle(),),
        ),
      body: ListView(
        children: [
          new Container(
                        width: 5.0,
                        height: 50,
                      ),
          Column(
          children: [
            Padding(
          padding: EdgeInsets.all(14.0),
          child: Text( "Effectué une Opération de "+this.nameop,
              style: TextStyle(fontSize: 16))
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 1;
                    this.nameop = "versement";
                  });
                },
              ),
              Text(
                'VEM',
                style: new TextStyle(fontSize: 17.0),
              ),

              Radio(
                value: 2,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 2;
                    this.nameop = "retrait";
                  });
                },
              ),
              Text(
                'RET',
                style: new TextStyle(
                  fontSize: 17.0,
                ),
              ),

              Radio(
                value: 3,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 3;
                    this.nameop = "virement";
                  });
                },
              ),
              Text(
                'VIR',
                style: new TextStyle(fontSize: 17.0),
              ),
            ],
            )
          ],
        ),
        this.id==1?versement():Container(),
        this.id==2?retraiit():Container(),
        this.id==3?virement():Container(),
        ],

      ),
    );
  }

  TextStyle textStyle(){
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black
    );
  }

Widget versement(){
  return Column(
              children: [

              new Container(
                        width: 5.0,
                        height: 50,
                      ),

              new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _montant,
                keyboardType: TextInputType.number,
                style: textStyle(),
                onChanged: (value){
                  montantv();
                  debugPrint("la valeur du titre");
                },
                decoration:new InputDecoration(
                  labelText: 'Entrer un montant',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )),

               Padding(
                 padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:new Text("valider",style: textStyle(),),
                        onPressed: (){
                          print("pas mal");
                          operation(widget.codew, '', 'ver', this.montant);
                        }),
               ),

              ],
            );
}

Widget retraiit(){
  return Column(
              children: [

              new Container(
                        width: 5.0,
                        height: 50,
                      ),

              new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _montant,
                keyboardType: TextInputType.number,
                style: textStyle(),
                onChanged: (value){
                  montantv();
                  debugPrint("la valeur du titre");

                },
                decoration:new InputDecoration(
                  labelText: 'Entrer un montant',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )),

               Padding(
                 padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:new Text("valider",style: textStyle(),),
                        onPressed: (){
                          print("pas mal");
                          operation(widget.codew, '', 'ret', this.montant);
                        }),
               ),

              ],
          );
}

montantv(){
  setState(() {
    this.montant = this._montant.text ;
  });
}

codeve(){
  setState(() {
    this.codev = this._codev.text;
  });
}


Widget virement(){
  return Column(
              children: [

              new Container(
                        width: 5.0,
                        height: 50,
                      ),

              new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _montant,
                keyboardType: TextInputType.number,
                style: textStyle(),
                onChanged: (value){
                  debugPrint("la valeur du titre");
                  montantv();
                },
                decoration:new InputDecoration(
                  labelText: 'Entrer un montant',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )),


              new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _codev,
                style: textStyle(),
                onChanged: (value){
                  debugPrint("la valeur du titre");
                  codeve();
                },
                decoration:new InputDecoration(
                  labelText: 'Entrer le code',
                  labelStyle: textStyle(),
                  border:new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              )),

               Padding(
                 padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:new Text("valider",style: textStyle(),),
                        onPressed: (){
                          print("pas mal");
                          operation(widget.codew, this.codev, 'vir', this.montant);
                    }),
               ),

              ],
        );
}


operation(String codep, String codev, String typop, String montant){
  var url = Uri.parse(GlobaleData.host+"/Operation");
    headers["Authorization"] = Authservice.token;
    final operation = json.encode({'codeCp':codep,
                                  'codeCpv':codev,
                                  'montant':montant,
                                  'typeOp':typop});
    http.post(url,body: operation,headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Authservice.token
    }).then((resp){
      print("versement reussi");
      DialogGood(context, "Opération de "+this.nameop, "l'opération éffectué avec succè");
    }).catchError((err){
      print("error versement");
       //DialogGood(context, "Opération de "+this.nameop, "Opération error");
    });
}

DialogGood(context,title,message) {
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
