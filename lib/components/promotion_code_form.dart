import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

// Define a custom Form widget.
class PromotionCodeForm extends StatefulWidget {
  const PromotionCodeForm

  ({super.key});

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
  String _code = '';
  DateTime _startTime = DateTime.now();
  DateTime _expireTime = DateTime.now();
  bool _enabled = false;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return
      AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
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
                  child: const Text("Submit"),
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      debugPrint(_code);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
  }

  Future<bool> _addPromotionCode() async {
      return true;

  }
}