import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satyr/models/user.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<UserModel>(
          builder: (context, user, child) {
            return Text("Satyr on ${user.url.toString()}");
          },
        ),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView(children: [
      _tile("Awex", "Sea of Thieves"),
      _tile("Awice", "Sea of Thieves"),
      _tile("kawen", "some nerd shit"),
    ]);
  }

  ListTile _tile(String username, String title) => ListTile(
        title: Text(username),
        subtitle: Text(title),
        trailing: Icon(
          Icons.tv,
          color: null,
        ),
      );
}
