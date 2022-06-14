import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Define a custom Form widget.
class PinPlayForm extends StatefulWidget {
  PinPlayForm({super.key, required this.token, required this.notifyParent});

  String token;

  void Function() notifyParent;

  @override
  PinPlayFormState createState() {
    return PinPlayFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class PinPlayFormState extends State<PinPlayForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];

  final _formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  String name = '';
  String? notice;
  DateTime startTime = DateTime.now().add(const Duration(days: 1));
  DateTime endTime = DateTime.now().add(const Duration(days: 7));
  DateTime openTime = DateTime.now();
  bool public = false;
  bool community = false;
  int minParticipants = 0;
  int maxParticipants = 999999;
  int rankLimit = 50;
  String? description;
  bool pinHistory = false;
  int? _id;
  String title = "핀플레이 생성";
  var tags = <Tag>[];
  double _fontSize = 14;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    List<Widget> items = [];
    tags.asMap().forEach((index, tag){
      Widget item = Container(
        height: 50,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 10,
              child: Container(
                width: 60,
                height: 30,
                alignment: Alignment.center,
                color: tag.backgroundColor,
                child: Text(
                  tag.tag,
                  style: TextStyle(
                      color: tag.textColor,
                      fontSize: 12
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 80,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tags[index].backgroundColor = Colors.green[300]!;
                      tags[index].textColor = Colors.white;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green[300],
                    ),
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Text(
                      'A',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                top: 0,
                left: 110,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tags[index].backgroundColor = Colors.blue[300]!;
                      tags[index].textColor = Colors.white;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Text(
                      'A',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                top: 0,
                left: 140,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tags[index].backgroundColor = Colors.red[300]!;
                      tags[index].textColor = Colors.white;
                    });
                  },
                  child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[300],
                  ),
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    'A',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

      items.add(item);
    });

    if(_id != null){
      title = "핀 플레이($_id) 수정";
    }
    return
      AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 400),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: '방이름 입력',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '방 이름을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              // 시작일
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("시작일"),
                    Text(DateFormat("yyyy-MM-dd").format(startTime)),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          initialDate: startTime,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        );

                        setState(() {
                          if(selectedDate != null){
                            startTime = selectedDate;
                          }

                        });

                      },
                    ),
                    // TextFormField(
                    //   initialValue: DateFormat("yyyy-MM-dd").format(_dateTime),
                    // ),
                  ],
                ),
              ),
              // 종료일
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("종료일"),
                    Text(DateFormat("yyyy-MM-dd").format(endTime)),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          initialDate: endTime,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        );
                        setState(() {
                          if(selectedDate != null){
                            endTime = selectedDate;
                          }

                        });
                      },
                    ),
                    // TextFormField(
                    //   initialValue: DateFormat("yyyy-MM-dd").format(_dateTime),
                    // ),
                  ],
                ),
              ),
              // 공개일
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("공개일"),
                    Text(DateFormat("yyyy-MM-dd").format(openTime)),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          initialDate: openTime,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        );
                        setState(() {
                          if(selectedDate != null){
                            openTime = selectedDate;
                          }
                        });
                      },
                    ),
                    // TextFormField(
                    //   initialValue: DateFormat("yyyy-MM-dd").format(_dateTime),
                    // ),
                  ],
                ),
              ),
              // 공개 유무
              Divider(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("공개"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Checkbox(
                      value: public,
                      onChanged: (value) async {
                        setState(() {
                          if(value != null){
                            public = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    const Text("커뮤니티"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Checkbox(
                      value: community,
                      onChanged: (value) async {
                        setState(() {
                          if(value != null){
                            community = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    const Text("핀내역"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Checkbox(
                      value: pinHistory,
                      onChanged: (value) async {
                        setState(() {
                          if(value != null){
                            pinHistory = value;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
              ),
              // 최소/최대 인원
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children: [
                      const Text("최소인원"),
                      SizedBox(
                          width: 10
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: minParticipants.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '최소인원',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty || double.parse(value) >= maxParticipants ) {
                              return '최소인원은 숫자이며 최대인원보다 작아야합니다.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            minParticipants = int.parse(value);
                          },
                        ),
                      ),
                      SizedBox(
                          width: 30
                      ),
                      const Text("최대인원"),
                      SizedBox(
                          width: 10
                      ),
                      Expanded(
                        flex:1,
                        child: TextFormField(
                          initialValue: maxParticipants.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '최대인원',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty || double.parse(value) <= minParticipants ) {
                              return '최대인원은 숫자이며 최소인원보다 커야합니다.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            maxParticipants = int.parse(value);
                          },
                        ),
                      )

                    ]
                ),
              ),
              // 핀 랭크 표시 순위
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children: [
                      const Text("랭크표시순위"),
                      SizedBox(
                          width: 10
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: rankLimit.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '핀랭크 표시 인원',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty || double.parse(value) == null ) {
                              return '숫자여야합니다.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            rankLimit = int.parse(value);
                          },
                        ),
                      ),
                    ]
                ),
              ),
              // 안내문구
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Palette.formBackgroundColor,
                    hintText: '안내문구 ',
                  ),
                  onSaved: (value) {
                    if(value != null){
                      notice = value;
                    }
                  },
                  onChanged: (value) {
                    if(value != null){
                      notice = value;
                    }
                  },
                ),
              ),
              // 태그
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    hintText: '태그 ',
                  ),
                  onFieldSubmitted: (value) {
                    setState((){
                      tags.add(Tag(tag: value));
                      _controller.clear();

                    });

                  },
                ),
              ),
              if(items.length > 0)
              Column(
                children: items,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      debugPrint(name);

                      await _addPinplay();
                    }
                    debugPrint(name);
                  },
                ),
              )
            ],
          ),
        ),
      );
  }

  Future<void> _addPinplay() async {
    final navigator = Navigator.of(context);
    String url = '$baseUrl/api/v3/pinplays';

    var addedTags = [];
    for(Tag tag in tags){
      addedTags.add({
        "name": tag.tag,
        "background_color": tag.bgColorToString,
        "text_color": tag.txtColorToString
      });
    }
    final body = jsonEncode({
      "name": name,
      "notice": notice,
      "started_at": DateFormat("yyyy-MM-dd").format(startTime),
      "ended_at": DateFormat("yyyy-MM-dd").format(endTime),
      "opened_at": DateFormat("yyyy-MM-dd").format(openTime),
      "display": public,
      "private": false,
      "rank_limit": rankLimit,
      "min_participants": minParticipants,
      "max_participants": maxParticipants,
      "community": community,
      "pins_history": pinHistory,
      "tags": addedTags
    });
    var message = '';
    try{
      http.Response? response;
      if(_id != null){
        response = await http.put(Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
            body: body
        );
      } else {
        response = await http.post(Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
            body: body
        );
      }
      if(response.statusCode < 300){
        message = "작업 성공";
        widget.notifyParent();
        navigator.pop();
      }
    } catch(e){
      message = e.toString();
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 24.0,
        webShowClose: true,
        webPosition: "center");

  }

}

class Tag {
  String tag;
  Color backgroundColor = Colors.green[300]!;
  Color textColor = Colors.white;
  Tag({required this.tag});

  String get bgColorToString{
    return backgroundColor.toString().replaceAll("Color(0x", "#").replaceAll(")", "");
  }
  String get txtColorToString{
    return textColor.toString().replaceAll("Color(0x", "#").replaceAll(")", "");
  }
}
