import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';
import 'package:http/http.dart' as http;

class ShowStudentDetail extends StatefulWidget {
  final String studentName;
  final String imagePath;
  final int id;

  const ShowStudentDetail(
      {Key? key,
      required this.studentName,
      required this.imagePath,
      required this.id})
      : super(key: key);
  _ShowStudentDetailState createState() => _ShowStudentDetailState(
      studentName: studentName, imagePath: imagePath, id: id);
}

class _ShowStudentDetailState extends State {
  final String studentName;
  final String imagePath;
  final int id;
  final nameController = TextEditingController();
  late XFile? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  _ShowStudentDetailState(
      {required this.studentName, required this.imagePath, required this.id})
      : _selectedFile = null;

  Future<void> _pickImage() async {
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedFile = image!;
    });
  }

  final namecontroller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _Name() {
    return TextFormField(
      controller: namecontroller,
      decoration: const InputDecoration(
          icon: Icon(Icons.verified_user), hintText: "Student Name"),
      validator: _validateName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Student"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue.shade300],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: _selectedFile != null
                              ? Image.file(
                                  File(_selectedFile!.path),
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                )
                              : Image.network(
                                  "http://192.168.8.100:3000/register/displayImage/$id",
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Student Name",
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.blue.shade700,
                            prefixIcon: Icon(Icons.verified_user),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Load Image"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            BlocProvider.of<StudentBloc>(context).add(
                              UpdateStudent(
                                studentName: nameController.text,
                                id: id,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Update Name"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
