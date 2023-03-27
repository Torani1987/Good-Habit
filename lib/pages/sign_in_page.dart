import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todolist_firebase/pages/phone_auth.dart';
import 'package:todolist_firebase/pages/sign_up_page.dart';
import 'package:todolist_firebase/services/auth_service.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0XFF1F2630),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              buttonItem(
                  'assets/images/google_logo.png', 'Continue with Google', 25,
                  (() async {
                await authService.googleSignIn(context);
              })),
              const SizedBox(
                height: 15,
              ),
              buttonItem(
                  'assets/images/telephone.png', 'Continue with Mobile ', 25,
                  (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PhoneAuth()));
              })),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Or',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              textItem('Email', 25, Icons.email, false, _emailController),
              const SizedBox(
                height: 15,
              ),
              textItem(
                  'Password', 25, Icons.password, true, _passwordController),
              const SizedBox(
                height: 25,
              ),
              colorButton(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'If you dont have an account ? ',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                          (route) => false);
                    }),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imgPath, String buttonName, double size, void Function()? ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imgPath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(buttonName),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(String labelName, double size, IconData icon, bool obscure,
      TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          label: Text(labelName),
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
          print(userCredential.user?.email);

          setState(() {});
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {});
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber[400],
        ),
        child: Center(
          child: Text(
            'Sign In',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
