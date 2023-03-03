import 'package:flutter/material.dart';
import 'package:hacker_news/core/provider/internet_connection/connectivity_provider.dart';
import 'package:hacker_news/view/home/home.dart';
import 'package:provider/provider.dart';

import 'core/provider/news_provider.dart';
import 'core/utils/connectionStatusSingleton.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        // ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );
  }
}
