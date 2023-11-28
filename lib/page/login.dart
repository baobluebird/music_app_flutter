import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_ui/page/app.dart';

import '../components/button.dart';
import '../screens/sign_in_screen.dart';
import '../screens/sign_up_screen.dart';
import '../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginScreen> {

  int backButtonPressCounter = 0;
  DateTime? currentBackPressTime;

  final myBox = Hive.box('myBox');
  late String storedToken;
  String serverMessage = '';

  Future<void> clearHiveBox(String boxName) async {
    var box = await Hive.openBox(boxName);
    await box.clear();
  }

  Future<void> _decodeToken(String token) async {
      try {
        final Map<String, dynamic> response =
        await DecodeTokenService.decodeToken(token);
        print('Response status: ${response['status']}');
        print('Response body: ${response['message']}');
        if (response['status'] == "success") {
          setState(() {
            serverMessage = response['message'];
          });
          print('Login successful');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyApp()));
          print(serverMessage);
        } else {
          setState(() {
            serverMessage = response['message'];
          });
          print('Login failed: ${response['message']}');
          print(serverMessage);
        }
      } catch (error) {
        setState(() {
          serverMessage = 'Error: $error';
        });
        print('Error: $error');
        print(serverMessage);
      }
  }
  @override
  void initState() {
    super.initState();

    //clearHiveBox('myBox');

    print("Amount of data is ${myBox.length}");
    storedToken = myBox.get('token', defaultValue: '');
    print('Stored Token: $storedToken');
    if(storedToken != ''){
      _decodeToken(storedToken);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (backButtonPressCounter < 1) {
          setState(() {
            backButtonPressCounter++;
            currentBackPressTime = DateTime.now();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press back again to exit."),
            ),
          );
          return false;
        } else {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            setState(() {
              backButtonPressCounter = 0;
            });
            return false;
          }
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 19, 18, 18),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 140),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Image.asset(
                          "assets/logo.png",
                          color: const Color.fromARGB(255, 10, 185, 121),
                          width: 250,
                        ),
                      ),
                      MyButton(
                        customColor: Colors.white.withOpacity(0.7),
                        text: "Sign In",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        customColor: const Color.fromARGB(255, 10, 185, 121),
                        text: "Create an account",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Terms of use",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
