import 'package:covid_detector/View/tempeture_check.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:covid_detector/Services/database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class MobileHomepage extends StatefulWidget {
  @override
  _MobileHomepageState createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {
  bool loading = true;
  File _image;
  List _output;
  bool _isButtonDisabled = false;
  final imagepicker = ImagePicker();

  Database _db = new Database();

  var getTemp = 0.0;
  final instaceDB = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction;
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assests/model_unquant.tflite', labels: 'assests/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickImage() async {
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: captureImageButton(),
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Image.asset(
                'assests/detector.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        _output != null
                            ? Text(
                                (_output[0]['label']).toString().substring(2) +
                                    " Detected!",
                                style: (_output[0]['label'])
                                            .toString()
                                            .substring(2) ==
                                        "No Mask"
                                    ? TextStyle(color: Colors.red, fontSize: 18)
                                    : TextStyle(
                                        color: Colors.tealAccent, fontSize: 18),
                              )
                            : Text(''),
                        Container(
                          height: 250,
                          width: 250,
                          padding: EdgeInsets.all(15),
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _output != null &&
                                (_output[0]['label']).toString().substring(2) ==
                                    "Mask"
                            ? tempPageButton()
                            : sendDBButton()
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      "Tap The Capture Button To Detect Mask!",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Container captureImageButton() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: _isButtonDisabled ? Colors.teal[900] : Colors.tealAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Capture',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: _isButtonDisabled
              ? () {}
              : () {
                  pickImage();
                  setState(() {
                    _isButtonDisabled = true;
                  });
                }),
    );
  }

  Container tempPageButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      height: 40,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: MaterialButton(
          color: Colors.green[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Check Tempreture',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          onPressed: () async {
            await _db.setScanTemp(1);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TempretureCheck(
                      tempData: getTemp,
                    )));
            setState(() {
              _isButtonDisabled = false;
            });
          }),
    );
  }

  Container sendDBButton() {
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
            _db.sendDataNoMaskVisitors("Visitor Was Not Wearing Mask");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Visitor Data Saved!')));
            setState(() {
              _isButtonDisabled = false;
            });
          }),
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
}
