import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/routes.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';

class ShowUserSettings extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const ShowUserSettings(
      {Key? key, required this.teacherName, required this.teacherPassword})
      : super(key: key);

  @override
  _ShowUserSettingsState createState() => _ShowUserSettingsState(
      teacherName: teacherName, teacherPassword: teacherPassword);
}

class _ShowUserSettingsState extends State<ShowUserSettings> {
  final String teacherName;
  final String teacherPassword;
  final namecontroller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ShowUserSettingsState(
      {required this.teacherName, required this.teacherPassword});

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
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: "Your Name",
        labelText: "Your Name",
        border: OutlineInputBorder(),
      ),
      validator: _validateName,
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("User Settings"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Name(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    BlocProvider.of<TeacherBloc>(context).add(
                      TeacherUpdate(
                        oldName: this.teacherName,
                        newName: this.namecontroller.text,
                        password: this.teacherPassword,
                      ),
                    );
                    BlocProvider.of<TeacherBloc>(context).close();
                    Navigator.of(buildContext)
                        .popAndPushNamed(RouteGenerator.loginPage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  "Update Name",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
