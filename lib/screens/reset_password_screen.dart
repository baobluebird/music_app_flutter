import 'package:flutter/material.dart';
import 'package:music_ui/screens/sign_in_screen.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../services/login_service.dart';


class ResetPassScreen extends StatefulWidget {
  final String idUser;
  const ResetPassScreen({super.key, required this.idUser});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool isError = true;
  String serverMessage = '';

  Future<void> _resetPass() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String password = _passwordController.text;
      final String confirmPassword = _confirmPasswordController.text;

      try {
        final Map<String, dynamic> response =
        await ResetPassService.resetPass(widget.idUser,password, confirmPassword);

        print('Response status: ${response['status']}');
        print('Response body: ${response['message']}');

        if (response['status'] == "success") {
          setState(() {
            serverMessage = response['message'];
            isError = false;
          });
          print('Change password successful');
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
              const SizedBox(height: 40),
              Image.asset("assets/logo.png",
                  color: const Color.fromARGB(255, 10, 185, 121), width: 300),
              MyTextField(
                inputController: _passwordController,
                hintText: "New password",
                onPressed: showPassword,
                errorInput: "Please enter your password",
                obsecureText: showPass ? false : true,
                icon: showPass ? Icons.visibility_off : Icons.visibility,
              ),
              const SizedBox(height: 12),
              MyTextField(
                inputController: _confirmPasswordController,
                hintText: "Confirm new password",
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

                    await _resetPass();
                    if(!isError){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(serverMessage),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
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
                text: "Reset Password",
                checkButton: _isLoading,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
