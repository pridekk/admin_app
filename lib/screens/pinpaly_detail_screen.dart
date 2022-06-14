import 'dart:io';
import 'dart:math';
import 'package:admin_app/components/simple_bar_chart.dart';
import 'package:admin_app/models/pinplay.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_app/models/promotion_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../config/palette.dart';
import '../models/admin_info.dart';
import '../models/spec_user.dart';


class PinPlayDetailScreen extends StatefulWidget {
  const PinPlayDetailScreen({Key? key, required this.playId}) : super(key: key);
  static const routeName = '/pinplay_detail';

  final int playId;

  @override
  State<PinPlayDetailScreen> createState() => _PinPlayDetailScreenState();
}

class _PinPlayDetailScreenState extends State<PinPlayDetailScreen> {

  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];

  Pinplay? pinplay;
  String token = "";

  @override
  Widget build(BuildContext context) {
    token = context.watch<AdminInfo>().token;
    if(token.length > 3 && pinplay == null){
      _getPinplay(widget.playId).then((value) {
        setState(() {
          pinplay = value;
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
    double width = MediaQuery.of(context).size.width;
    Widget playInfo;
    Widget gridView;
    debugPrint("${pinplay?.users}");
    if(pinplay == null){
      playInfo = Center(child: const CircularProgressIndicator());
      gridView = Center(child: const CircularProgressIndicator());
    } else {
      List<Widget> items = [];
      debugPrint("users: ${pinplay!.userList.length}");
      for(PinplayUser user in pinplay!.userList ){
        debugPrint("adding ${user.userId}");
        Widget item =
        SizedBox(
            width: 40,
            height: 40,
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${user.userId}"),
                        Text("수익률: ${user.profit}"),
                        Text("핀설정횟수: ${user.pinWithinPeriod}"),
                        Text("참여일: ${user.joinedAt}"),
                      ],
                    )
                  ],
                ),
              ),
            )
        );
        items.add(item);
      }

      gridView = GridView.count(
        shrinkWrap: true,
        childAspectRatio: 2,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: width > 1000 ? 4 : 1,
        children: items,
      );

      playInfo = Padding(
        padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                pinplay!.name
              )
            ],
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:Text('Pinplay: ${widget.playId}'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: playInfo
          ),
          const Divider(
            thickness: 3,
          ),
          Expanded(
            flex: 10,
            child: gridView,
          )],
      ),
    );
  }

  Future<Pinplay> _getPinplay(int id) async {

    var url = Uri.parse('$baseUrl/api/v3/pinplays/$id');

    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    var code = jsonDecode(utf8.decode(response.bodyBytes) );

    return (Pinplay.fromJson(code));

  }

}

