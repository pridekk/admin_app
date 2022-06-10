import 'dart:io';
import 'package:admin_app/components/simple_bar_chart.dart';
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


class PromotionUsersScreen extends StatefulWidget {
  const PromotionUsersScreen({Key? key, required this.promotionCode}) : super(key: key);
  static const routeName = '/promotion_users';

  final PromotionCode promotionCode;

  @override
  State<PromotionUsersScreen> createState() => _PromotionUsersScreenState();
}

class _PromotionUsersScreenState extends State<PromotionUsersScreen> {

  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];

  PromotionCode? promotionCode;
  String token = "";
  var filteredDate = "";

  @override
  Widget build(BuildContext context) {
    token = context.watch<AdminInfo>().token;
    if(token.length > 3 && promotionCode == null){
      _getPromotionCode(widget.promotionCode.id).then((value) {
        setState(() {
          promotionCode = value;
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
    Widget gridView;
    Widget chart;
    debugPrint("${promotionCode?.users}");
    if(promotionCode == null){
      gridView = Center(child: const CircularProgressIndicator());
      chart = Center(child: const CircularProgressIndicator());
    } else {
      List<Widget> items = [];
      for(SpecUser user in promotionCode!.userList ){
        if(filteredDate.isNotEmpty && user.promotionDate != filteredDate){
            continue;
        }
        debugPrint("adding ${user.username}");
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
                    if (user.image.startsWith("http"))
                    CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      backgroundImage: NetworkImage(user.image),
                    ),
                    if (!user.image.startsWith("http"))
                      CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${user.userId}"),
                        Text("이름: ${user.username}"),
                        Text("EMAIL: ${user.email}"),
                        Text("닉네임: ${user.email}"),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("등록일"),
                        Text("${user.promotionDate}")
                      ],
                    ),

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

      chart = SelectionCallbackExample.withData(promotionCode!.getChartData(),filterByDate);
    }

    return Scaffold(
      appBar: AppBar(
        title:Text('프로모션: ${widget.promotionCode.code} 참여자'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child:
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("참여자수: ${widget.promotionCode.users} "),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("참여기간: ${widget.promotionCode.startedAt} ~${widget.promotionCode.expiredAt ?? ""} "),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: ()  async {
                            setState(() {
                              filteredDate = "";
                            });
                          },
                          tooltip: "필터 초기화",
                          icon: const Icon(Icons.restart_alt)
                      ),
                      IconButton(
                          onPressed: ()  async {

                            Clipboard.setData(ClipboardData(text: promotionCode!.getClipboardUserData()));
                            Fluttertoast.showToast(
                                msg: "Copied!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Palette.backgroundColor,
                                textColor: Colors.white,
                                fontSize: 24.0,
                                webShowClose: true,
                                webPosition: "center");
                          },
                          tooltip: "전체 사용자 Clipboard COPY",
                          icon: const Icon(Icons.copy_all_outlined)
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
          Expanded(
            flex: 3,

            child: chart
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

  Future<PromotionCode> _getPromotionCode(int id) async {

    var url = Uri.parse('$baseUrl/api/v3/promotions/$id');

    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    var code = jsonDecode(utf8.decode(response.bodyBytes) );

    return (PromotionCode.fromJson(code));

  }


  void filterByDate(String date){
    setState(() {
      filteredDate = date;
    });
  }

}

