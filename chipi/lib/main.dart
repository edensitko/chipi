import 'package:chipi/providers/models_provider.dart';
import 'package:chipi/providers/userprovider.dart';
import 'package:chipi/screens/firstsplash.dart';
import 'package:chipi/screens/splashScreen.dart';
import 'package:chipi/providers/userprovider.dart';
import 'package:chipi/screens/firstsplash.dart';
import 'package:chipi/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
                ChangeNotifierProvider(create: (_) => UserProvider()),

      ],
      child: MaterialApp(
        title: 'chipi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
initialRoute: '/',
      routes: {
       
        '/': (context) => FirstSplashScreen(),
         '/splash': (context) => SplashScreen(),
        '/home': (context) => ChatScreen() // מסך הבית שאליו ננווט
      },      ),
    );
  }
}
