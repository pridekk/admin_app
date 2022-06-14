import 'package:admin_app/models/promotion_code.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:provider/provider.dart';

import '../models/admin_info.dart';
// Define a custom Form widget.
class PromotionCodeForm extends StatefulWidget {
  PromotionCodeForm({super.key, this.code, required this.notifyParent});

  PromotionCode? code;

  final Function() notifyParent;

  @override
  PromotionCodeFormState createState() {
    return PromotionCodeFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class PromotionCodeFormState extends State<PromotionCodeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];
  int? _id;
  String _code = '';
  DateTime _startTime = DateTime.now();
  DateTime _expireTime = DateTime.now();
  bool _enabled = false;
  String token = "";

  bool updated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.code != null){

      _code = widget.code!.code;
      _startTime = DateTime.parse(widget.code!.startedAt);
      _expireTime = DateTime.parse(widget.code!.expiredAt ?? '2050-12-31');
      _enabled = widget.code!.enabled;
      _id = widget.code!.id;

    }
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    token = context.watch<AdminInfo>().token;
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _code,
                decoration: const InputDecoration(
                  hintText: '코드 입력',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _code = value!;
                },
                onChanged: (value) {
                  _code = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("시작일"),
                  Text(DateFormat("yyyy-MM-dd").format(_startTime)),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _startTime,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                      );

                      setState(() {
                        if(selectedDate != null){
                          _startTime = selectedDate;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("종료일"),
                  Text(DateFormat("yyyy-MM-dd").format(_expireTime)),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _expireTime,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                      );
                      setState(() {
                        if(selectedDate != null){
                          _expireTime = selectedDate;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const Text("활성화"),
                  const SizedBox(
                    width: 40.0,
                  ),
                  Checkbox(
                    value: _enabled,
                    onChanged: (value) async {
                      setState(() {
                        if(value != null){
                          _enabled = value;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: _id == null ? const Text("등록"): const Text("수정"),
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    debugPrint(_code);
                  }

                  await _updatePromotionCode();

                },
              ),
            )
          ],
        ),
      ),
    );


  }

  Future<void> _updatePromotionCode() async {
    final navigator = Navigator.of(context);
    String url = '$baseUrl/api/v3/promotions';
    if(_id != null){
      url += "/$_id";
    }


    final body = jsonEncode(<String,dynamic>{
      "code": _code,
      "started_at": DateFormat("yyyy-MM-dd").format(_startTime),
      "expired_at": DateFormat("yyyy-MM-dd").format(_expireTime),
      "enabled": _enabled
    });

    var message = '';
    try{
      http.Response? response;
      if(_id != null){
        response = await http.put(Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
            body: body
        );
      } else {
        response = await http.post(Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
            body: body
        );
      }
      if(response.statusCode < 300){
        message = "작업 성공";
        setState(() {
          updated = true;
        });
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