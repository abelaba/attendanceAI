import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/routes.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';
import 'package:project/teacher/bloc/TeacherState.dart';
import 'package:project/teacher/models/Teachers.dart';

class LoginPage extends StatefulWidget {
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: "User Name",
        prefixIcon: Icon(Icons.person),
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
        prefixIcon: Icon(Icons.lock),
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
      // resizeToAvoidBottomInset: false,
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
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
          } else if (state is TeacherError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Could not log in"),
            ));
          }
        },
        builder: (context, state) {
          return BlocBuilder<TeacherBloc, TeacherState>(
            builder: (context, state) {
              return Stack(
                children: [
                  _buildBackgroundImage(), // Background image
                  _buildBlurEffect(), // Blur effect
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to\nAttendance AI",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildNameField(),
                                SizedBox(height: 20),
                                _buildPasswordField(),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<TeacherBloc>(context).add(
                                        FetchATeacher(
                                          new Teacher(
                                            name: nameController.text,
                                            password: passwordController.text,
                                            id: 0,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF00AEEF),
                                    onPrimary: Colors.white,
                                    minimumSize: Size(150, 44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 3.0,
                                  ),
                                  child: Text("Login"),
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      RouteGenerator.singupPage,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Text("Sign Up"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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
