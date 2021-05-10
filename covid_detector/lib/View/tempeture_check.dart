import 'package:covid_detector/Services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TempretureCheck extends StatefulWidget {
  final double tempData;

  const TempretureCheck({Key key, @required this.tempData}) : super(key: key);
  @override
  _TempretureCheckState createState() => _TempretureCheckState();
}

class _TempretureCheckState extends State<TempretureCheck> {
  Database _db = new Database();
  var _firebaseRef = FirebaseDatabase()
      .reference()
      .child('currentVisitor')
      .child('temperature');

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: _firebaseRef.onValue,
          builder: (context, snapshot) {
            return Container(
              height: h,
              width: w,
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  snapshot.data.snapshot.value != null
                      ? Text(
                          "Temprature Scanning\nComplete",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.tealAccent, fontSize: 25),
                        )
                      : Text(
                          "Temprature Scanning\nIn Progress!",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.tealAccent, fontSize: 25),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  snapshot.data.snapshot.value != null
                      ? Text(snapshot.data.snapshot.value.toString(),
                          style: snapshot.data.snapshot.value > 37
                              ? TextStyle(color: Colors.red, fontSize: 45)
                              : TextStyle(color: Colors.green, fontSize: 45))
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  snapshot.data.snapshot.value != null &&
                          snapshot.data.snapshot.value < 37
                      ? Container(
                          height: 300,
                          width: 300,
                          child: Image(
                            image: AssetImage('assests/flowcode.png'),
                            fit: BoxFit.contain,
                          ),
                        )
                      : snapshot.data.snapshot.value != null &&
                              snapshot.data.snapshot.value > 37
                          ? sendDBButton(snapshot.data.snapshot.value)
                          : Container(),
                  SizedBox(
                    height: 25,
                  ),
                  snapshot.data.snapshot.value != null &&
                          snapshot.data.snapshot.value < 37
                      ? sendDBButtonForNormal(snapshot.data.snapshot.value)
                      : Container(),
                ],
              ),
            );
          }),
    ));
  }

  Container sendDBButton(tempData) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      height: 40,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Save Visitor Data',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          onPressed: () {
            Map<String, dynamic> visitorMap = {
              'm': "Visitor Was Wearing Mask but temp was high",
              'temp': tempData,
            };
            _db.sendDataMaskVisitors(visitorMap);
            _firebaseRef.remove().then((value) => Navigator.of(context).pop());
          }),
    );
  }

  Container sendDBButtonForNormal(tempData) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      height: 40,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Confirm QR Scan',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          onPressed: () {
            Map<String, dynamic> visitorMap = {
              'm': "Visitor Was Wearing Mask and temp was okay",
              'temp': tempData,
            };
            _db.sendDataMaskVisitors(visitorMap);
            _firebaseRef.remove().then((value) => Navigator.of(context).pop());
          }),
    );
  }
}
