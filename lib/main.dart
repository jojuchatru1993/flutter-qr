import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr2/pages/home_page.dart';
import 'package:qr2/pages/map_page.dart';

import 'package:qr2/providers/scan_list_provider.dart';
import 'package:qr2/providers/ui_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new UiProvider()),
        ChangeNotifierProvider(create: (_) => new ScanListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'map': (_) => MapPage(),
        },
        theme: ThemeData(
            primaryColor: Colors.black,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.black)),
      ),
    );
  }
}
