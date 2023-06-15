import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';

class CreateStudentWidget extends StatefulWidget {
  const CreateStudentWidget({
    Key? key,
  }) : super(key: key);

  @override
  _CreateStudentWidgetState createState() => _CreateStudentWidgetState();
}

class _CreateStudentWidgetState extends State<CreateStudentWidget> {
  final classnamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  late XFile _selectedFile = XFile(""); // Initialize with an empty file path
  final ImagePicker _picker = ImagePicker();

  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _StudentName() {
    return TextFormField(
      controller: classnamecontroller,
      decoration: InputDecoration(
        hintText: "Student Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: _nameValidator,
    );
  }

  Widget _SelectedImage() {
    if (_selectedFile.path.isEmpty) {
      return Container(
        child: Center(
          child: Icon(
            Icons.image,
            size: 250,
          ),
        ),
      ); // Display a placeholder image here
    } else {
      return Image.file(
        File(_selectedFile.path),
        width: 250,
        height: 250,
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Create Student"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SelectedImage(),
                    SizedBox(
                      height: 10,
                    ),
                    _StudentName(),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        "Add Image",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          BlocProvider.of<StudentBloc>(context).add(
                            CreateStudent(
                              name: classnamecontroller.text,
                              image: _selectedFile,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        "Create Student",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
