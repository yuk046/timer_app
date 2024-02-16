import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AddPage extends StatelessWidget {
   AddPage({Key? key}) : super(key:key);

  String first = '';
  String last = '';
  int? year;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
            decoration: InputDecoration(
              hintText: 'First Nmae',
            ),
            onChanged: (text) {
                first = text;
            }
            ),
            TextField(
            decoration: InputDecoration(
              hintText: 'Last Nmae',
            ),
            onChanged: (text) {
                last = text;
            }
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'age',
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                year = int.tryParse(text);
              },
            ),
            ElevatedButton(
              onPressed: ()async{
              await _addToFirebase();
              Navigator.pop(context);
            }, 
            child: Text('追加する')),
          ],
        ),
      ),
    );
  }

    Future _addToFirebase() async {
   final db = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "first": first,
      "last": last,
      "born": year
    };

  // Add a new document with a generated ID
  await db.collection("users").add(user);
  }
}