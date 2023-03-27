import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist_firebase/services/auth_service.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneNumber = TextEditingController();
  AuthService authService = AuthService();
  int start = 30;
  bool wait = false;
  String buttonName = 'Send';
  String verificationID = "";
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF1F2630),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0XFF1F2630),
        title: Text(
          'Verify Your Account',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Lottie.asset('assets/lotties/phone.json'),
              const SizedBox(
                height: 50,
              ),
              textField(),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text(
                      "Enter 6 digit OTP ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              otpField(),
              SizedBox(
                height: 20,
              ),
              colorButton(),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Send OTP Again In",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TextSpan(
                      text: " 00:$start",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent),
                    ),
                    TextSpan(
                      text: " sec",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          inactiveColor: Colors.white,
          inactiveFillColor: Color(0XFF1F2630),
          selectedFillColor: Colors.white,
          selectedColor: Colors.amberAccent,
          activeColor: Colors.white,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Color(0XFF1F2630),
        enableActiveFill: true,
        onCompleted: (pin) {
          print("Completed" + pin);
          setState(() {
            smsCode = pin;
          });
        },
        onChanged: (value) {
          print(value);
          setState(() {});
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: phoneNumber,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Phone Number",
          hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Text(
              '(+62)',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : (() async {
                    startTimer();
                    setState(() {
                      start = 30;
                      wait = true;
                      buttonName = 'Resend';
                    });
                    await authService.phoneVerify(
                        "+62${phoneNumber.text}", context, setData);
                  }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Text(
                buttonName,
                style: TextStyle(
                    color: wait ? Colors.grey : Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: (() {
        authService.signInWithPhoneNumber(verificationID, smsCode, context);
      }),
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber[400],
        ),
        child: Center(
          child: Text(
            'Verify',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void setData(verificationId) {
    setState(() {
      verificationID = verificationId;
    });
    startTimer();
  }
}
