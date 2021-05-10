import 'package:covid_detector/View/admin.dart';
import 'package:covid_detector/View/mobile_homepage.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Center(child: userLogin(context)),
            SizedBox(
              height: 25,
            ),
            Center(child: adminLogin(context))
          ])),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
      title: Text(
        'COVID Detector',
      ),
    );
  }

  Container userLogin(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      height: 40,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: Colors.tealAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Log In As User',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MobileHomepage()));
          }),
    );
  }

  Container adminLogin(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      height: 40,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Log In As Admin',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Admin()));
          }),
    );
  }
}
