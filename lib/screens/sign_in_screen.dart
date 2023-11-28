import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_ui/screens/sign_up_screen.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../services/login_service.dart';
import '../page/app.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final myBox = Hive.box('myBox');

  bool _isLoading = false;
  bool isError = true;
  String serverMessage = '';
  String token ='';
  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      try {
        final Map<String, dynamic> response =
            await SignInService.signIn(email, password);

        print('Response status: ${response['status']}');
        print('Response body: ${response['message']}');
        print('Response body: ${response['access_token']}');
        if (response['status'] == "success") {
          token = response['access_token'];
          await myBox.put('id', response['id']);
          await myBox.put('name', response['name']);
          setState(() {
            serverMessage = response['message'];
            isError = false;
          });
          print('Login successful');
        } else {
          setState(() {
            serverMessage = response['message'];
            isError = true;
          });
          print('Login failed: ${response['message']}');
        }
      } catch (error) {
        setState(() {
          isError = true;
          serverMessage = 'Error: $error';
        });
        print('Error: $error');
      }
    }
  }

  Future<void> remember() async{
    await myBox.put('token', token);
  }

  bool showPass = false;
  bool checkTheBox = false;

  showPassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  check() {
    setState(() {
      checkTheBox = !checkTheBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 18, 18),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  "assets/logo.png",
                  color: const Color.fromARGB(255, 10, 185, 121),
                  width: 300,
                ),
                const SizedBox(height: 40),
                MyTextField(
                  hintText: "Email",
                  inputController: _emailController,
                  errorInput: "Please enter your email",
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: "Password",
                  inputController: _passwordController,
                  onPressed: showPassword,
                  obsecureText: showPass ? false : true,
                  errorInput: "Please enter your password",
                  icon: showPass ? Icons.visibility_off : Icons.visibility,
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.grey[500],
                            ),
                            child: Checkbox(
                              checkColor: Colors.white,
                              value: checkTheBox ? true : false,
                              onChanged: (bool? value) {
                                check();
                              },
                            ),
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 10, 185, 121),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!_isLoading) {
                      setState(() {
                        _isLoading = true;
                      });
                      await _signIn();
                      if (!isError) {
                        if(checkTheBox){
                          await remember();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(serverMessage),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(serverMessage),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  customColor: const Color.fromARGB(255, 10, 185, 121),
                  checkButton: _isLoading,
                  text: "Sign In",
                ),
                const SizedBox(height: 20),
                const Text("Or Sign In with",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      child: Image.asset(
                        "assets/facebook.png",
                        width: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      child: Image.asset(
                        "assets/google.png",
                        width: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      child: const Icon(
                        Icons.apple,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                          color: Color.fromARGB(255, 10, 185, 121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
