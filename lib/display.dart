import 'package:flutter/material.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future getPosts() async {

var firestore = Firestore.instance;
QuerySnapshot qn = await firestore.collection("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/Information Technology/Information Technology").getDocuments();
return qn.documents;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(builder: (_, snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child:Text("loading...."),
            );
            }
            else{
              return ListView.builder(
                // itemCount: snapshot.data.length,
                itemCount: 1000,
                // itemExtent: 300,
                itemBuilder: (_, index){
                    return ListTile(
                      title: Text(snapshot.data[index].data["Legal"]),
                    );
                }
              );           
        }
      },
      )
    );
  }
}

// class Datavalue extends StatefulWidget {
//   @override
//   _DatavalueState createState() => _DatavalueState();
// }

// class _DatavalueState extends State<Datavalue> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }