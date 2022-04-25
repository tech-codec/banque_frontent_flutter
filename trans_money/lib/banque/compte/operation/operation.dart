import 'package:flutter/material.dart';
import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'package:trans_money/banque/compte/operation/typeOperation.dart';
import 'package:trans_money/banque/services/authservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Operation extends StatefulWidget {

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {

  final TextEditingController _code = TextEditingController();

  String code='';

  Map<String, String> headers = new Map();

  Map<String, dynamic> compte = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: ListView(children: [
            Column(
              children: [

              new Container(
                        width: 5.0,
                        height: 180,
                      ),

              new Padding(padding: EdgeInsets.all(8.0),
              child:new TextField(
                controller: _code,
                style: textStyle(),
                onChanged: (value){
                  debugPrint("la valeur du titre");

                },
                decoration:new InputDecoration(
                  labelText: 'Entrer votre code',
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
                          getCompte(this._code);
                        }),
               ),

              ],
            )
          ],),
        ),
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

getCompte(TextEditingController codef){
  setState(() {
    this.code = codef.text;
    var url = Uri.parse(GlobaleData.host+"/comptes/"+this.code);
    headers["Authorization"] = Authservice.token;
    http.get(url,headers: headers).then((resp){
      this.compte = json.decode(resp.body);
      print("le code est correte et existe");
      DialogGood(context, "verification de code", "votre code est correcte");
    }).catchError((err){
      print("le code est incorecte");
      DialogBade(context, "verifiacation de code", "votre code est incorecte");
    });
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
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TypeOperation(this.code)));
          print(this.code);
        },
      ),
    ],
  );
});

}

DialogBade(context,title,message) {
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
