import 'package:flutter/material.dart';
import 'package:pickerv2/models/Choicesoperation.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/form_validator.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String DescriptionText = "";
  final FocusScopeNode _node = FocusScopeNode();
  final validate =
      ValidationBuilder().minLength(1, 'Length < 1 😟').maxLength(1500).build();
  GlobalKey<FormState> _form = GlobalKey();
  void done() {
    if (_form.currentState!.validate()) {
      Provider.of<ChoicesOperation>(context, listen: false)
          .addNewChoice(DescriptionText);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("AddChoice"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: FocusScope(
            node: _node,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      done();
                    },
                    validator: validate,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 18,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      border: InputBorder.none,
                      hintText: 'Enter Choice',
                      hintStyle: TextStyle(fontSize: 24, color: Colors.white),
                      labelText: 'Choice',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    onChanged: (value) {
                      DescriptionText = value;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    done();
                  },
                  child: Text(
                    'Add Choice',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
