import 'package:firebase_database/firebase_database.dart';

class Database {
  final instaceDB = FirebaseDatabase.instance;

  //send data to firebase for visitors
  sendDataNoMaskVisitors(data) {
    final ref = instaceDB.reference();
    return ref.child('appData').push().child('nM').set(data).asStream();
  }

  //set ScanTemp to 1
  setScanTemp(data) {
    final ref = instaceDB.reference();
    return ref.child('currentVisitor').child('scanTemp').set(data).asStream();
  }

  //set data to firebase for masked visitors
  sendDataMaskVisitors(data) {
    final ref = instaceDB.reference();
    return ref.child('appData').push().set(data).asStream();
  }
}
