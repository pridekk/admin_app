import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_app/models/promotion_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../models/admin_info.dart';
import '../models/spec_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
var dio = Dio();

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
    debugPrint("${promotionCode?.users}");
    if(promotionCode == null){
      gridView = Center(child: const CircularProgressIndicator());
    } else {
      List<Widget> items = [];
      for(SpecUser user in promotionCode!.userList ){
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("참여자수: ${widget.promotionCode.users}"),
                ),
                IconButton(
                    onPressed: ()  async {
                      debugPrint("Auth: Bearer ${token.substring(0,10)}");
                      if(kIsWeb){
                        var _url = Uri.parse( '$baseUrl/v3/promotions/${widget.promotionCode.id}');
                        token = "Bearer $token";
                        if (!await launchUrl(_url,
                          webViewConfiguration: WebViewConfiguration(
                            enableDomStorage: false,
                            enableJavaScript: false,
                            headers: <String, String>{'Authorization': token}
                          ),)) throw 'Could not launch $_url';
                      } else {
                        var tempDir = await getTemporaryDirectory();
                        String fullPath = tempDir.path + "/boo2.pdf'";
                        print('full path ${fullPath}');

                        download2(dio, '$baseUrl/v3/promotions/${widget.promotionCode.id}', fullPath);
                      }
                    },
                    icon: const Icon(Icons.add_circle))
              ],
            )
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

    var url = Uri.parse('$baseUrl/v3/promotions/$id');

    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    var code = jsonDecode(utf8.decode(response.bodyBytes) );

    return (PromotionCode.fromJson(code));

  }
  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              if(status != null){
                return status < 500;
              } else {
                return true;
              }

            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }
  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}

