import 'package:cmm/src/scoped_models/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './src/pages/home_page.dart';
import './src/scoped_models/app_provider.dart';

main() => runApp(CMM());

class CMM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: ChangeNotifierProvider<AppProvider>(
        create: (context) => AppProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              bodyText2: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          home: Scaffold(
            body: Homepage(),
          ),
        ),
      ),
    );
  }
}
