import 'dart:convert';
import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:admin_app/models/pin_profit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/admin_info.dart';

class PinplayChart extends StatefulWidget {
  const PinplayChart({Key? key, required this.playId}) : super(key: key);

  final int playId;

  @override
  State<PinplayChart> createState() => _PinplayChartState();
}

class _PinplayChartState extends State<PinplayChart> {
  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];
  String token = "";
  bool isLoaded = false;

  List<PinProfit> pinProfits = [];
  @override
  Widget build(BuildContext context) {
    token = context.watch<AdminInfo>().token;
    if(token.length > 3 && isLoaded == false){
      getPinProfit().then((value) {
        setState(() {
          pinProfits = value;
          isLoaded = true;
        });
      }, onError: (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 24.0,
            webShowClose: true,
            webPosition: "center");
      });
    }
    final List<charts.Series> seriesList;
    var chart = charts.PieChart(_createSampleData(),
        animate: true,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 60)
    );
    return Container(
      width: 400,
        height: 500,
        child: chart
    );
  }

  Future<List<PinProfit>> getPinProfit() async{
    List<PinProfit> profits = [];

    var url = Uri.parse('$baseUrl/api/v3/pinplays/${widget.playId}/pins');
    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var pins = jsonDecode(utf8.decode(response.bodyBytes) );

    for (Map<String, dynamic> pin in pins) {
      profits.add(PinProfit.fromJson(pin));
    }

    return profits;
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}