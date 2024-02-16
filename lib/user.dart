import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String first;
  final String last;
  final String born;

  User({
  required this.id,
  required this.first,
  required this.last,
  required this.born
  });

  factory User.fromFirestore(DocumentSnapshot doc){
  final data = doc.data() as Map<String, dynamic>;
  return User(
    id: doc.id,
    first: data['first'],
    last: data['last'],
    born: data['born'].toString(),
  );
}
}
