import 'package:admin_app/components/pinplay_form.dart';
import 'package:admin_app/screens/pinpaly_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:timelines/timelines.dart';
import '../components/pinplay_search_form.dart';
import '../models/admin_info.dart';
import '../models/pinplay.dart';
import 'package:countup/countup.dart';

class PinPlaysScreen extends StatefulWidget {
  const PinPlaysScreen({Key? key}) : super(key: key);
  static const routeName = '/pinplays';

  @override
  State<PinPlaysScreen> createState() => _PinPlaysScreenState();
}

class _PinPlaysScreenState extends State<PinPlaysScreen> {
  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  var plays = <Pinplay>[];
  String token = "";
  bool isLoaded = false;

  String? query;
  bool? deleted;
  bool? private;
  bool? display;
  bool? admin;
  String? roomType;
  DateTime? startedFrom;
  DateTime? startedTo;
  DateTime? endedFrom;
  DateTime? endedTo;

  void reloadPinPlays({
    String? query,
    bool? deleted,
    bool? private,
    bool? display,
    bool? admin,
    String? roomType,
    DateTime? startedFrom,
    DateTime? startedTo,
    DateTime? endedFrom,
    DateTime? endedTo,
  }){
    setState(() {
      this.query = query;
      this.deleted = deleted;
      this.private = private;
      this.display = display;
      this.admin = admin;
      this.roomType = roomType;
      this.startedFrom = startedFrom;
      this.startedTo = startedTo;
      this.endedFrom = endedFrom;
      this.endedTo = endedTo;
      isLoaded = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    token = context.watch<AdminInfo>().token;
    if(token.length > 3 && isLoaded == false) {
      _getPinPlays().then((value) {
        setState(() {
          plays = value;
          isLoaded = true;
        });
      }, onError: (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 32.0,
            webShowClose: true,
            webPosition: "center");
      });
    }

    debugPrint("build Pin Plays");
    return
      Column(
        children: [
          PinPlaySearchBar(notifyParent: reloadPinPlays),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context)
                        {
                          return PinPlayForm(
                            notifyParent: (){
                              setState((){
                                isLoaded = false;
                              });
                            },
                            token: token,
                          );
                        }
                    );
                  },
                  icon: const Icon(Icons.add_circle))
            ],
          ),
          if(isLoaded == false)
          Center(
            child: CircularProgressIndicator(),
          ),
          if(isLoaded)
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: plays.length,

              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context,
                        PinPlayDetailScreen.routeName,
                        arguments: plays[index].id
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(10),

                      child:
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${plays[index].id}"),
                                ],
                              ),
                            ), Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(plays[index].name),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("상태:${plays[index].roomStatus}"),

                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("생성일: ${plays[index].createdAt}"),
                                  Text("시작일: ${plays[index].startedAt}"),
                                  Text("종료일: ${plays[index].endAt}"),
                                  Text("공개일: ${plays[index].openedAt}" )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("공개:"),
                                      Switch(value: plays[index].isPublic, onChanged: (value){}),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("삭제:"),
                                      Switch(value: plays[index].isDeleted, onChanged: (value){}),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("참여자수:"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Countup(
                                        begin: 0,
                                        end: plays[index].users as double? ?? 0,
                                        duration: const Duration(seconds: 1),
                                        separator: ',',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("핀수:"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Countup(
                                        begin: 0,
                                        end: plays[index].pins as double? ?? 0,
                                        duration: const Duration(seconds: 1),
                                        separator: ',',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                           ],
                        )
                    )
                );
              }
            )
          ),
        ],
      );
    }

    // children: [
    //   Text("생성일: ${plays[index].createdAt}"),
    //   Text("시작일: ${plays[index].createdAt}"),
    //   Text("종료일: ${plays[index].createdAt}")
    // ],
    // ]),
    //   );

  Future<List<Pinplay>> _getPinPlays() async {
    List<Pinplay> result = <Pinplay>[];


    String base = '$baseUrl/api/v3/pinplays?';
    if(query != null){
      base += "&query=$query";
    }

    if(display != null){
      base += "&display=$display";
    }
    if(deleted != null){
      base += "&deleted=$deleted";
    }
    if(admin != null){
      base += "&admin=$admin";
    }
    if(private != null){
      base += "&private=$private";
    }
    if(startedTo != null){
      base += "&started_to=$startedTo";
    }
    if(startedFrom != null){
      base += "&started_from=$startedFrom";
    }
    if(endedTo != null){
      base += "&ended_to=$endedTo";
    }
    if(endedFrom != null){
      base += "&ended_from=$endedFrom";
    }
    base = base.replaceAll("?&", "?");

    if(base.endsWith("?")){
      base = base.replaceAll("?", "");
    }
    var url = Uri.parse(base);


    var response = await http.get(url);

    var codes = jsonDecode(utf8.decode(response.bodyBytes));

    for (Map<String, dynamic> code in codes['pinplays']) {
      result.add(Pinplay.fromJson(code));
    }

    return result;
  }

}
