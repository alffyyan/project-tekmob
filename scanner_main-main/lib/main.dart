import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scanner_main/router.dart';
import 'package:scanner_main/styles/styles.dart';
import 'package:scanner_main/ui/app_scaffold.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme:ThemeData(fontFamily: $styles.text.body.fontFamily),
      builder: (BuildContext context, Widget? child) {
        return ScanyAppScaffold(child: child!);
      },
    );
  }
}


AppStyle get $styles => ScanyAppScaffold.style;

Logger get $logger => ScanyAppScaffold.logger;
