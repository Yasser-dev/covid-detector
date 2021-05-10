class ChartData {
  ChartData({this.xValue, this.yValue});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : xValue = dataMap['temp'],
        yValue = dataMap['m'];
  final double xValue;
  final String yValue;
}
