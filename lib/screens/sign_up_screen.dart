import 'package:flutter/material.dart';
import 'package:music_ui/screens/sign_in_screen.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../services/login_service.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool isError = true;
  String serverMessage = '';

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String confirmPassword = _confirmPasswordController.text;
      try {
        final Map<String, dynamic> response =
        await SignUpService.signUp(name,email, password, confirmPassword);

        print('Response status: ${response['status']}');
        print('Response body: ${response['message']}');

        if (response['status'] == "success") {
          setState(() {
            serverMessage = response['message'];
            isError = false;
          });
          print('Create successful');
        } else {
          setState(() {
            serverMessage = response['message'];
            isError = true;
          });
          print('Create failed: ${response['message']}');
        }
      } catch (error) {
        setState(() {
          serverMessage = 'Error: $error';
          isError = true;
        });
        print('Error: $error');
      }
    }
  }

  bool showPass = false;
  bool showConfirm = false;

  showConfPass() {
    setState(() {
      showConfirm = !showConfirm;
    });
  }

  showPassword() {
    setState(() {
      showPass = !showPass;
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset("assets/logo.png",
                  color: const Color.fromARGB(255, 10, 185, 121), width: 300),
              MyTextField(
                inputController: _nameController,
                hintText: "Name",
                errorInput: "Please enter your name",
              ),
              const SizedBox(height: 12),
              MyTextField(
                inputController: _emailController,
                hintText: "Email",
                errorInput: "Please enter your email",
              ),
              const SizedBox(height: 12),
              MyTextField(
                inputController: _passwordController,
                hintText: "Password",
                onPressed: showPassword,
                errorInput: "Please enter your password",
                obsecureText: showPass ? false : true,
                icon: showPass ? Icons.visibility_off : Icons.visibility,
              ),
              const SizedBox(height: 12),
              MyTextField(
                inputController: _confirmPasswordController,
                hintText: "Confirm Password",
                onPressed: showConfPass,
                errorInput: "Please enter your confirm password",
                obsecureText: showConfirm ? false : true,
                icon: showConfirm ? Icons.visibility_off : Icons.visibility,
              ),
              const SizedBox(height: 30),
              MyButton(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });

                    await _signUp();
                    if(!isError){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(serverMessage),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    }else{
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
                text: "Sign Up",
                checkButton: _isLoading,
              ),
              const SizedBox(height: 20),
              const Text("Or Sign Up with",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
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
                              builder: (context) => const SignInScreen()));
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Color.fromARGB(255, 10, 185, 121),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
