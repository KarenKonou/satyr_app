import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satyr/models/app.dart';
import 'package:http/http.dart' as http;

enum Menu { live, url, login, logout, register }

class Streamers {
  final List<Streamer> streamers;

  Streamers({this.streamers});

  factory Streamers.fromJson(Map<String, dynamic> json) {
    var list = json['users'] as List;
    List<Streamer> streamersList =
        list.map((s) => Streamer.fromJson(s)).toList();

    return Streamers(streamers: streamersList);
  }
}

class Streamer {
  final String username;
  final String title;

  Streamer({this.username, this.title});

  factory Streamer.fromJson(Map<String, dynamic> json) {
    return Streamer(username: json['username'], title: json['title']);
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _liveOnly = false;
  Future<Streamers> _futureStreamers;

  Future<Streamers> fetchStreamers() async {
    final opts = Provider.of<AppModel>(context, listen: false);
    String url;

    if (_liveOnly) {
      url = opts.url.toString() + "/api/users/live";
    } else {
      url = opts.url.toString() + "/api/users/all";
    }

    final response = await http.post(url, body: "");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Streamers.fromJson(data);
    } else {
      throw Exception('Failed to fetch streamers');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureStreamers = fetchStreamers();
  }

  Future<void> _refreshStreamers() async {
    setState(() {
      _futureStreamers = fetchStreamers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Consumer<AppModel>(
            builder: (context, user, child) {
              return Text("Satyr on ${user.url.toString()}");
            },
          ),
          actions: <Widget>[_popupMenu()]),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return FutureBuilder<Streamers>(
        future: _futureStreamers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tiles = snapshot.data.streamers
                .map((data) => _tile(data.username, data.title))
                .toList();
            return RefreshIndicator(
              onRefresh: _refreshStreamers,
              child: ListView(
                children: tiles,
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        });
  }

  ListTile _tile(String username, String title) => ListTile(
        title: Text(username),
        subtitle: Text(title),
        trailing: Icon(
          Icons.tv,
          color: null,
        ),
      );

  Widget _popupMenu() => PopupMenuButton<Menu>(
        onSelected: (Menu result) {
          switch (result) {
            case Menu.live:
              _liveOnly = !_liveOnly;
              _refreshStreamers();
              break;

            case Menu.login:
              Navigator.pushReplacementNamed(context, '/login');
              break;

            case Menu.register:
              Navigator.pushReplacementNamed(context, '/register');
              break;

            case Menu.logout:
              setState(() {
                Provider.of<AppModel>(context, listen: false).logout();
              });
              break;

            case Menu.url:
              Navigator.pushReplacementNamed(context, '/');
              break;
          }
        },
        itemBuilder: _buildMenuItems,
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

    if (Provider.of<AppModel>(context, listen: false).loggedIn) {
      baseList.add(
          const PopupMenuItem<Menu>(value: Menu.logout, child: Text("Logout")));
    } else {
      baseList.add(
          const PopupMenuItem<Menu>(value: Menu.login, child: Text("Login")));
      baseList.add(const PopupMenuItem<Menu>(
          value: Menu.register, child: Text("Register")));
    }

    return baseList;
  }
}
