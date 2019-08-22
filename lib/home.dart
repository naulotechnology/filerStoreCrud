import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'readwrite.dart';
import 'display.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  // StreamSubscription<DocumentSnapshot> subscription;
  PlanningFormModel pfm = new PlanningFormModel();
  

  void add(){
    // pfm.add1();
    // pfm.add2();
    // pfm.savepfmToFirebasePlan();
    // pfm.savepfmToFirebaseActual();
    pfm. savepfmToFirebase();
    // pfm.add3();
  }

 void check(){
    // pfm.add1();
  //print(ma.monthlyActualToList());
  // print(pfm.toStringMp());
 // print(pfm.montlyActualHrs);
  //  print(pfm.stringMp() ) ;
    //  print(pfm.mActual.monthlyActualToList());
   // print(pfm.mActual.monthlyActualToJson());
   print(pfm.checkInternetConnectivity());
  }


  final DocumentReference documentReference =
      // Firestore.instance.document("myData/dummy");
      Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/Transportation/Transportation");



  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Firebase Demo"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: () {
                setState(() {
                  add();
                });
              },
              child: new Text("Add"),
              color: Colors.cyan,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _delete,
              child: new Text("Delete"),
              color: Colors.orange,
            ),
              new RaisedButton(
              onPressed:() {
                setState(() {
                   pfm.checkInternetConnectivity();
                  // pfm.checkInternet();
                });
              },
             
              child: new Text("check"),
              color: Colors.orange,
            ),
            
          ],
        ),
      ),
    );
  }
}


















