import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/screens/home.page.dart';
import 'package:flutter_application_2/screens/login.page.dart';
import 'package:flutter_application_2/screens/register.page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
    
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      useMaterial3: true,
    ),
    title: 'ladynoire fantastic project (fail)',
    //home: HomePage(),
    initialRoute: '/login',
    routes: {
      '/login':(context)=>LoginPage(),
      '/register':(context)=>RegisterPage(),
      '/home':(context)=>HomePage(),
    },
  );
}
}