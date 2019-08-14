import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'readwrite.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  // StreamSubscription<DocumentSnapshot> subscription;
  PlanningFormModel pfm = new PlanningFormModel();

  final DocumentReference documentReference =
      // Firestore.instance.document("myData/dummy");
      Firestore.instance.document(
          "/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/Transportation/Transportation");



  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  
  void add(){
    // pfm.add1();
    pfm.add2();
    // pfm.add3();
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
          ],
        ),
      ),
    );
  }
}

// String id;
// final db = Firestore.instance;
// final _formKey = GlobalKey<FormState>();
// String name;

// Card buildItem(DocumentSnapshot doc) {
//   return Card(
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             'name: ${doc.data['name']}',
//             style: TextStyle(fontSize: 24),
//           ),
//           Text(
//             'todo: ${doc.data['todo']}',
//             style: TextStyle(fontSize: 20),
//           ),
//           SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[

//               FlatButton(
//                 onPressed: () => updateData(doc),
//                 child: Text('Update todo', style: TextStyle(color: Colors.white)),
//                 color: Colors.green,
//               ),
//               SizedBox(width: 8),
//               FlatButton(
//                 onPressed: () => deleteData(doc),
//                 child: Text('Delete'),
//               ),
//             ],
//           )
//         ],
//       ),
//     ),
//   );
// }

// TextFormField buildTextFormField() {
//   return TextFormField(
//     decoration: InputDecoration(
//       border: InputBorder.none,
//       hintText: 'name',
//       fillColor: Colors.grey[300],
//       filled: true,
//     ),
//     validator: (value) {
//       if (value.isEmpty) {
//         return 'Please enter some text';
//       }
//     },
//     onSaved: (value) => name = value,
//   );
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Firestore CRUD'),
//     ),
//     body: ListView(
//       padding: EdgeInsets.all(8),
//       children: <Widget>[
//         Form(
//           key: _formKey,
//           child: buildTextFormField(),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             RaisedButton(
//               onPressed: createData,
//               child: Text('Create', style: TextStyle(color: Colors.white)),
//               color: Colors.green,
//             ),
//             RaisedButton(
//               onPressed: id != null ? readData : null,               ///if readdata = null then dont cant pressed the read buttton
//               child: Text('Read', style: TextStyle(color: Colors.white)),
//               color: Colors.blue,
//             ),
//           ],
//         ),

//         StreamBuilder<QuerySnapshot>(

//           stream: db.collection('CRUD').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
//             } else {
//               return SizedBox();
//             }
//           },
//         )
//       ],
//     ),
//   );
// }

// void createData() async {
//   if (_formKey.currentState.validate()) {
//     _formKey.currentState.save();
//     DocumentReference ref = await db.collection('CRUD').add({'name': '$name ', 'todo': "this is todo"});
//     setState(() => id = ref.documentID);
//     print(ref.documentID);
//   }
// }

// void readData() async {
//   DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
//   print(snapshot.data['name']);
// }

// void updateData(DocumentSnapshot doc) async {
//   await db.collection('CRUD').document(doc.documentID).updateData({'todo': 'updated'});
// }

// void deleteData(DocumentSnapshot doc) async {
//   await db.collection('CRUD').document(doc.documentID).delete();
//   setState(() => id = null);
// }

// }
