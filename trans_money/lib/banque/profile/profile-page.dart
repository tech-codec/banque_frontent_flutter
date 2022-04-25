import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'dart:convert';

import 'package:trans_money/banque/banqueconfig/globalevariable.dart';
import 'package:trans_money/banque/services/authservice.dart';


class Profile extends StatefulWidget {

  String usernameW;
  Profile(this.usernameW);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String nameImage='';
  final TextEditingController _username = TextEditingController();
  final TextEditingController _useremail = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username='';
  String email='';

  Map<String, String> headers = new Map();

  Map<String, dynamic> user = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.image),
                    title: (this.nameImage=='' && user['photo']!=null)
                        ? Image.network(GlobaleData.host +"/userImage/${this.user["id"]}",width: 150,headers:{'Authservice.token':Authservice.token})
                        : this.nameImage!=''?Image.file(new File(this.nameImage)):Text("Pas de photo"),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () =>_selectAvatar(context),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.title_outlined),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: ""+widget.usernameW),
                      controller: _username,
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
                    leading: Icon(Icons.email),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: ""+user['email'].toString()),
                     controller: _useremail,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if(value.length == 0) {
                          return "Entrer name";
                        }
                        return null;
                      },
                    ),
                  ),

                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("Anuler"),
                    onPressed: () {
                      setState(() {
                        this.nameImage = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Modifier"),
                    onPressed: () {
                      _save(this._username,this._useremail);
                    },
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


Future _selectAvatar(BuildContext inContext) {
    return showDialog(
      context: inContext,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image, color: Colors.blue,),
                    Text("Avatar"),
                  ],
                ),
                Divider(),
                GestureDetector(
                  child: ListTile(
                    leading: Icon(Icons.camera_enhance),
                    title: Text("Prendre une photo"),
                  ),
                  onTap: () async {
                    var cameraImage = await ImagePicker.pickImage(
                      source: ImageSource.camera
                    );
                    if(cameraImage != null) {
                      setState(() {
                        this.nameImage = cameraImage.path;
                      });
                      print(this.nameImage);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Galerie"),
                  ),
                  onTap: () async {
                    var galleryImage = await ImagePicker.pickImage(
                      source: ImageSource.gallery
                    );
                    if(galleryImage != null) {
                      setState(() {
                        this.nameImage = galleryImage.path;
                      });
                      print(this.nameImage);
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }


void loadUser(){
    var url = Uri.parse(GlobaleData.host+"/findUser/"+widget.usernameW);
    headers["Authorization"] = Authservice.token;
     http.get(url,headers: headers)
    .then((resp){
      setState((){
         this.user =json.decode(resp.body);
         print(user);
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



  void updateuser(String usernamef, String emailf, int iduser){
    if(usernamef==''){
      usernamef = user['username'];
    }
    if(emailf==''){
      emailf = user['email'];
    }
    var url = Uri.parse(GlobaleData.host+"/users/"+user['id'].toString());
    final userform = json.encode({'username':usernamef,
                                  'email':emailf,
                                  'password':user['password'],
                                  'photo':user['photo']});
    headers["Authorization"] = Authservice.token;
    http.put(url,body: userform,headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Authservice.token
    }).then((rep) {
      if(this.nameImage!=''){
        uploadphoto(iduser);
      }
      print("user modifie avec succes");
    }).catchError((err){
      print("erreur de modification user");
    });
  }
  void uploadphoto(int iduser){
    var url = Uri.parse(GlobaleData.host+"/Uploadphotomobille/"+user['id'].toString());
    File imageFile = new File(this.nameImage);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);
    final imageform = json.encode({'imageBase64':base64Image});
    headers["Authorization"] = Authservice.token;
    http.post(url,body: imageform,headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Authservice.token
    }).then((rep){
      print("photo charger avec succes");
    }).catchError((err){
      print("erreur de chargement d'image ");
    });
  }

  void _save(TextEditingController nameUser,TextEditingController emailUser){
    setState(() {
      this.username = nameUser.text;
      this.email = emailUser.text;
      updateuser(this.username,this.email, user['id']);
      DialogGood(context, "modification profile", "profile modiffié avec succes");
    });

  }

}
