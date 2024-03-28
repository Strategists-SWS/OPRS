import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService{

  final CollectionReference paperCollection = FirebaseFirestore.instance.collection('papers');

}