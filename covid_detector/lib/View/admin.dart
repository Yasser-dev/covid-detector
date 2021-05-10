import 'package:covid_detector/Model/ChartData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final dataRef = FirebaseDatabase.instance.reference().child("appData");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.bar_chart)),
                Tab(icon: Icon(Icons.line_style))
              ],
            ),
            title: Text('Admin Dashboard'),
          ),
          body: TabBarView(
            children: [
              Container(
                  child: StreamBuilder<Event>(
                stream: dataRef.onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snap) {
                  Widget widget;
                  if (snap.data != null) {
                    List<ChartData> chartData = <ChartData>[];
                    Map data = snap.data.snapshot.value;
                    for (Map childData in data.values) {
                      // here we are storing the data into a list which is used for chart’s data source
                      chartData.add(
                          ChartData.fromMap(childData.cast<String, dynamic>()));
                    }
                    widget = Container(
                        child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(
                          text: 'Temp Analysis Between people\nWho wear mask'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<ChartData, dynamic>>[
                        BarSeries(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.yValue,
                          yValueMapper: (ChartData data, _) => data.xValue,
                        ),
                      ],
                    ));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return widget;
                },
              )),
              Container(
                  child: StreamBuilder<Event>(
                stream: dataRef.onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snap) {
                  Widget widget;
                  if (snap.data != null) {
                    List<ChartData> chartData = <ChartData>[];
                    Map data = snap.data.snapshot.value;
                    for (Map childData in data.values) {
                      // here we are storing the data into a list which is used for chart’s data source
                      chartData.add(
                          ChartData.fromMap(childData.cast<String, dynamic>()));
                    }
                    widget = Container(
                        child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Temp Analysis of visitors'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<ChartData, dynamic>>[
                        LineSeries<ChartData, dynamic>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.yValue,
                            yValueMapper: (ChartData data, _) => data.xValue,
                            name: 'temp',
                            // Enable data label
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ],
                    ));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return widget;
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
