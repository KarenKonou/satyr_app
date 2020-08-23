import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satyr/models/user.dart';

enum Menu { live, url, login, logout }

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _liveOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Consumer<UserModel>(
            builder: (context, user, child) {
              return Text("Satyr on ${user.url.toString()}");
            },
          ),
          actions: <Widget>[_popupMenu()]),
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

  Widget _popupMenu() => PopupMenuButton<Menu>(
        onSelected: (Menu result) {
          switch (result) {
            case Menu.live:
              setState(() {
                _liveOnly = !_liveOnly;
              });
              break;

            case Menu.login:
              Navigator.pushReplacementNamed(context, '/login');
              break;

            case Menu.logout:
              setState(() {
                Provider.of<UserModel>(context, listen: false).logout();
              });
              break;

            case Menu.url:
              Navigator.pushReplacementNamed(context, '/');
              break;
          }
        },
        itemBuilder: _buildMenuItems,
      );

  ListTile _tile(String username, String title) => ListTile(
        title: Text(username),
        subtitle: Text(title),
        trailing: Icon(
          Icons.tv,
          color: null,
        ),
      );

  List<PopupMenuEntry<Menu>> _buildMenuItems(BuildContext context) {
    final baseList = <PopupMenuEntry<Menu>>[
      CheckedPopupMenuItem<Menu>(
        checked: _liveOnly,
        value: Menu.live,
        child: Text("Only show currently live streams"),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<Menu>(
          value: Menu.url, child: Text("Change instance")),
    ];

    if (Provider.of<UserModel>(context, listen: false).loggedIn) {
      baseList.add(
          const PopupMenuItem<Menu>(value: Menu.logout, child: Text("Logout")));
    } else {
      baseList.add(
          const PopupMenuItem<Menu>(value: Menu.login, child: Text("Login")));
    }

    return baseList;
  }
}
