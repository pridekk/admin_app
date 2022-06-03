import 'package:flutter/material.dart';

// Define a custom Form widget.
class PromotionCodeForm extends StatefulWidget {
  const PromotionCodeForm({super.key});

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
  late String code  = '';
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
                        hintText: '코드 입력',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        code = value!;
                      },
                      onChanged: (value) {
                        code = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InputDatePickerFormField(
                      firstDate: DateTime.now(),
                      lastDate: DateTime.utc(2030,12,31),
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
                          debugPrint(code);
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
}