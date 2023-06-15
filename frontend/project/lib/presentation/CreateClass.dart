import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';

class CreateClass extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const CreateClass({
    Key? key,
    required this.teacherName,
    required this.teacherPassword,
  }) : super(key: key);

  @override
  _CreateClassState createState() =>
      _CreateClassState(teacherName, teacherPassword);
}

class _CreateClassState extends State<CreateClass> {
  final String teacherName;
  final String teacherPassword;
  final classnamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();

  _CreateClassState(this.teacherName, this.teacherPassword);

  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _ClassName() {
    return TextFormField(
      controller: classnamecontroller,
      decoration: InputDecoration(
        hintText: "Class Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: _nameValidator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Class"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      key: _scaffoldKey,
      body: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ClassName(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (classnamecontroller.text == null ||
                          classnamecontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Name can't be empty"),
                        ));
                      } else {
                        BlocProvider.of<ClassBloc>(context).add(
                          CreateAClass(
                            classnamecontroller.text,
                            teacherName,
                            teacherPassword,
                          ),
                        );
                        Navigator.of(context).popAndPushNamed(
                          RouteGenerator.showClasses,
                          arguments: ScreenArguments(
                            classId: 0,
                            className: classnamecontroller.text,
                            name: teacherName,
                            password: teacherPassword,
                          ),
                        );
                      }
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
                      "Create a Class",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
