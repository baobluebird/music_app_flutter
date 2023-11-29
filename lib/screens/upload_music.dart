import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_ui/components/button.dart';
import 'package:music_ui/components/text_field.dart';

import '../services/music_service.dart';

class DashedBorder extends StatelessWidget {
  final Widget child;
  final double dashWidth;
  final double dashGap;

  DashedBorder({
    required this.child,
    this.dashWidth = 3.0,
    this.dashGap = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(dashWidth: dashWidth, dashGap: dashGap),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double dashWidth;
  final double dashGap;

  DashedBorderPainter({required this.dashWidth, required this.dashGap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54 // Adjust the color of the dashed border
      ..strokeWidth = 2.0; // Adjust the width of the dashed border

    final double startX = 0;
    final double endX = size.width;
    final double startY = 0;
    final double endY = size.height;

    // Draw top border
    double currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(Offset(currentX, startY),
          Offset(currentX + dashWidth, startY), paint);
      currentX += dashWidth + dashGap;
    }

    // Draw right border
    double currentY = startY;
    while (currentY < endY) {
      canvas.drawLine(
          Offset(endX, currentY), Offset(endX, currentY + dashWidth), paint);
      currentY += dashWidth + dashGap;
    }

    // Draw bottom border
    currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(
          Offset(currentX, endY), Offset(currentX + dashWidth, endY), paint);
      currentX += dashWidth + dashGap;
    }

    // Draw left border
    currentY = startY;
    while (currentY < endY) {
      canvas.drawLine(Offset(startX, currentY),
          Offset(startX, currentY + dashWidth), paint);
      currentY += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class UploadMusicScreen extends StatefulWidget {
  const UploadMusicScreen({Key? key}) : super(key: key);

  @override
  State<UploadMusicScreen> createState() => _UploadMusicScreenState();
}

class _UploadMusicScreenState extends State<UploadMusicScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
  final TextEditingController _singerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final myBox = Hive.box('myBox');
  bool _isLoading = false;
  bool isError = true;
  String serverMessage = '';
  String _idUser= '';
  File? _image;
  File? _music;

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print(_music);
        final Map<String, dynamic> response =
            await CreateMusicService.createMusic(
                _idUser,
                _nameController.text,
                _genresController.text,
                _singerController.text,
                _descriptionController.text,
                _image,
                _music);

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
    setState(() {
      _image = im;
    });
  }

  Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        return File(file.path!);
      } else {
        throw Exception('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  selectFile(BuildContext context) async {
    File? file = await pickFile();
    if (file != null) {
      setState(() {
        _music = file;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File uploaded successfully!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
@override
void initState() {
  super.initState();
  _idUser = myBox.get('id', defaultValue: '');
}
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _genresController.dispose();
    _singerController.dispose();
    _descriptionController.dispose();
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
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(_image!),
                            backgroundColor: Colors.black38,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://icons-for-free.com/iconfiles/png/512/music-131964753036631366.png'),
                            backgroundColor: Colors.black38,
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
                SizedBox(height: 12),
                MyTextField(
                  inputController: _nameController,
                  hintText: "Music name",
                  errorInput: "Please enter your music name",
                ),
                const SizedBox(height: 12),
                MyTextField(
                  inputController: _genresController,
                  hintText: "Genres",
                  errorInput: "Please enter your musician",
                ),
                const SizedBox(height: 12),
                MyTextField(
                  inputController: _singerController,
                  hintText: "Musician",
                  errorInput: "Please enter your genres",
                ),
                const SizedBox(height: 12),
                MyTextField(
                  inputController: _descriptionController,
                  hintText: "Description",
                  errorInput: "Please enter your description",
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => selectFile(context),
                  child: DashedBorder(
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: _music == null
                          ? Center(
                        child: Icon(
                          Icons.upload,
                          size: 80,
                          color: Colors.blue[500],
                        ),
                      )
                          : Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.black.withOpacity(0.7),
                              child: Column(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.music_note,
                                      size: 80,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        _music != null ? _music!.path.split('/').last : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      if (!isError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(serverMessage),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
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
                  text: "Upload",
                  checkButton: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
