import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todolist_firebase/pages/add_todo.dart';
import 'package:todolist_firebase/pages/home_page.dart';
import 'package:todolist_firebase/pages/sign_up_page.dart';
import 'package:todolist_firebase/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignUpPage();
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
  }

  void checkLogin() async {
    String? token = await authService.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: const SignUpPage());
  }
}
