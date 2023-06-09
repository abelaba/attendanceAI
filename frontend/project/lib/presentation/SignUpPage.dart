import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';
import 'package:project/teacher/bloc/TeacherState.dart';
import 'package:project/teacher/models/Teachers.dart';
import '../../routes.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: "User Name",
        prefixIcon: Icon(Icons.verified_user),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      validator: _validateName,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.vpn_key),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      obscureText: true,
      validator: _validatePassword,
    );
  }

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return "Password should be greater than 8";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildBackgroundImage(), // Background image
              _buildBlurEffect(), // Blur effect
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildNameField(),
                        SizedBox(height: 20),
                        _buildPasswordField(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                Color(0xFF00AEEF), // Vibrant futuristic blue
                            onPrimary: Colors.white,
                            minimumSize: Size(234, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 3.0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (state is OneTeacherLoaded) {
                                Navigator.of(context).pushNamed(
                                  RouteGenerator.otherPage,
                                  arguments: ScreenArguments(
                                    classId: 0,
                                    className: "",
                                    name: nameController.text,
                                    password: passwordController.text,
                                  ),
                                );
                              } else {
                                BlocProvider.of<TeacherBloc>(context).add(
                                  CreateTeacher(
                                    new Teacher(
                                      name: nameController.text,
                                      password: passwordController.text,
                                      id: 0,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("Sign Up"),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF2A2A2A), // Dark metallic gray
                          ),
                          child: Text("Back"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/background.jpeg', // Replace with your background image URL
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBlurEffect() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }
}
