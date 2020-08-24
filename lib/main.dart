import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satyr/common/theme.dart';
import 'models/app.dart';
import 'package:satyr/screens/home.dart';
import 'package:satyr/screens/instance_select.dart';
import 'package:satyr/screens/login.dart';
import 'package:satyr/screens/register.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => AppModel(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Satyr',
      theme: appTheme,
      initialRoute: (Provider.of<AppModel>(context, listen: false).url != null)
          ? '/home'
          : '/',
      routes: {
        '/': (context) => MyInstanceSelect(),
        '/login': (context) => MyLogin(),
        '/home': (context) => MyHome(),
        '/register': (context) => MyRegister(),
      },
    );
  }
}
