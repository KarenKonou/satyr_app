import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satyr/models/app.dart';

class MyInstanceSelect extends StatefulWidget {
  @override
  _MyInstanceSelectState createState() => _MyInstanceSelectState();
}

class _MyInstanceSelectState extends State<MyInstanceSelect> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Welcome to Satyr"),
          Container(
            margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                  decoration: InputDecoration(hintText: "Instance URL"),
                  onSaved: (value) {
                    Provider.of<AppModel>(context, listen: false)
                        .setUrl(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter some text";
                    }
                    return null;
                  }),
            ),
          ),
          SizedBox(height: 24),
          RaisedButton(
            color: Colors.green,
            child: Text('ENTER'),
            onPressed: () {
              _formKey.currentState.save();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ]),
      ),
    );
  }
}
