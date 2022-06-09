import 'package:admin_app/components/pin_play_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:timelines/timelines.dart';
import '../models/pin_play.dart';
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
  var plays = <PinPlay>[];

  var searchTitle = "";

  @override
  initState() {
    super.initState();

    _getPinPlays().then((value) {
      setState(() {
        plays = value;
      });
    }, onError: (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 24.0,
          webShowClose: true,
          webPosition: "center");
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build Pin Plays");
    return

      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context)
                        {
                          return const PinPlayForm();
                        }
                    );
                  },
                  icon: const Icon(Icons.add_circle))
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: plays.length,

              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),

                  child:
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
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
                        SizedBox(
                          width: 200,
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
                        SizedBox(
                          width: 200,
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
                        Column(
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
                                  end: plays[index].users as double,
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
                                  end: plays[index].pins as double,
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
                       ],
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

  Future<List<PinPlay>> _getPinPlays() async {
    List<PinPlay> result = <PinPlay>[];

    var url = Uri.parse('${baseUrl!}/v3/pinplays');

    var response = await http.get(url);

    var codes = jsonDecode(response.body);

    for (Map<String, dynamic> code in codes['data']) {
      result.add(PinPlay.fromJson(code));
    }

    return result;
  }

}
