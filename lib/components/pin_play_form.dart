import 'package:admin_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

// Define a custom Form widget.
class PinPlayForm extends StatefulWidget {
  const PinPlayForm

  ({super.key});

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
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _openTime = DateTime.now();
  bool _public = false;
  int minParticipants = 0;
  int maxParticipants = 999999;
  int rankLimit = 50;
  String? description;
  bool pinHistory = false;
  var tags = <Tag>[];
  double _fontSize = 14;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return
      AlertDialog(
        content: Stack(
          children: <Widget>[

            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                        _name = value!;
                      },
                      onChanged: (value) {
                        _name = value;
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
                        Text(DateFormat("yyyy-MM-dd").format(_endTime)),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _endTime,
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2030),
                            );
                            setState(() {
                              if(selectedDate != null){
                                _endTime = selectedDate;
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
                        const Text("공개일"),
                        Text(DateFormat("yyyy-MM-dd").format(_openTime)),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _openTime,
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2030),
                            );
                            setState(() {
                              if(selectedDate != null){
                                _openTime = selectedDate;
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

                        const Text("공개"),
                        const SizedBox(
                          width: 40.0,
                        ),
                        Checkbox(
                          value: _public,
                          onChanged: (value) async {
                            setState(() {
                              if(value != null){
                                _public = value;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
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
                          _name = value;
                        }
                      },
                      onChanged: (value) {
                        if(value != null){
                          _name = value;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.go,
                      decoration: const InputDecoration(
                        hintText: '태그 ',
                      ),
                      onFieldSubmitted: (value) {
                        setState((){
                          tags.add(Tag(tag: value));
                        });
                      },
                    ),
                  ),
                  if(tags.length > 0)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(tags[0].tag)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          debugPrint(_name);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }

  Future<bool> _addPromotionCode() async {
      return true;

  }
}

class Tag {
  String tag;
  String backgroundColor = "#FFFFFF";
  String color = "#FFFFFF";
  Tag({required this.tag});
}
