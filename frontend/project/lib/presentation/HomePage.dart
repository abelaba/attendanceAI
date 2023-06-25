import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/routes.dart';
import 'package:project/teacher/bloc/bloc.dart';

class HomePage extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const HomePage(
      {Key? key, required this.teacherName, required this.teacherPassword})
      : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(
      teacherName: teacherName, teacherPassword: teacherPassword);
}

class _MyStatefulWidgetState extends State {
  final String teacherName;
  final String teacherPassword;

  _MyStatefulWidgetState(
      {required this.teacherName, required this.teacherPassword});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance ")),
      body: Center(
        child: Text('Show and see attendance'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Attendance management system'),
            ),
            ListTile(
              title: const Text('Take Attendance'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.takeAttendance,
                    arguments: new ScreenArguments(
                        classId: 0,
                        className: "",
                        name: this.teacherName,
                        password: this.teacherPassword));
              },
            ),
            ListTile(
              title: const Text('Classes'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.showClasses,
                    arguments: new ScreenArguments(
                        classId: 0,
                        className: "",
                        name: this.teacherName,
                        password: this.teacherPassword));
              },
            ),
            ListTile(
              title: const Text('Students'),
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteGenerator.showAllStudents,
                  arguments: ScreenArguments(
                      classId: 0,
                      className: "",
                      name: this.teacherName,
                      password: this.teacherPassword),
                );
              },
            ),
            ListTile(
              title: const Text('Your settings'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.showUserSettings,
                    arguments: ScreenArguments(
                        classId: 0,
                        className: "",
                        name: this.teacherName,
                        password: this.teacherPassword));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                BlocProvider.of<TeacherBloc>(context).close();
                Navigator.of(context).popAndPushNamed(RouteGenerator.loginPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
