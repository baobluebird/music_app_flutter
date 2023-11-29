import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:music_ui/page/app.dart';
import 'package:path_provider/path_provider.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../ipconfig/ipconfig.dart';
import '../services/login_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateUserScreen extends StatefulWidget {
  final String idUser;
  final String name;
  const UpdateUserScreen({super.key, required this.idUser, required this.name});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool isError = true;
  String serverMessage = '';
  Uint8List? _image;
  File? _imgSend;

  Future<Uint8List?> getImageFromServer(String id) async {
    var url = 'http://$ip:3003/api/user/get-image/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      List<int> byteData = List<int>.from(jsonResponse['image']['data']['data']);

      Uint8List imageData = Uint8List.fromList(byteData);

      setState(() {
        _image = imageData;
      });

      return imageData;
    } else {
      print('Failed to load image: ${response.statusCode}');
      return null;
    }
  }


  Future<void> _updateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if(_imgSend == null){
          _imgSend = File((await getTemporaryDirectory()).path + '/temp.png');
          await _imgSend!.writeAsBytes(_image!);
        }
        if(_nameController.text == ''){
          _nameController.text = widget.name;
        }
        final Map<String, dynamic> response =
            await UpdateUserService.updateUser(
                widget.idUser, _nameController.text, _imgSend!);

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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }
@override
void initState() {
  super.initState();
  getImageFromServer(widget.idUser);
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

  Future<File> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile == null) {
        throw Exception('No image selected.');
      }

      return File(pickedFile.path);
    } catch (e) {
      print('Error picking image: $e');
      throw e;
    }
  }

  selectImage() async {
    File im = await pickImage(ImageSource.gallery);
    List<int> bytes = await im.readAsBytes();
    Uint8List uint8List = Uint8List.fromList(bytes);
    setState(() {
      _image = uint8List;
      _imgSend = im;

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 40),
              Image.asset("assets/logo.png",
                  color: const Color.fromARGB(255, 10, 185, 121), width: 300),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              MyTextField(
                inputController: _nameController,
                hintText: "New name",
                errorInput: "Please enter your new name",
              ),
              const SizedBox(height: 30),
              MyButton(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(_image == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please choose your avatar"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });

                    await _updateUser();
                    if (!isError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(serverMessage),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()));
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
                text: "Update User",
                checkButton: _isLoading,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
