import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/routes.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';
import 'package:project/utils/constants.dart';

class ShowAllStudents extends StatefulWidget {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  const ShowAllStudents({
    Key? key,
    required this.className,
    required this.classId,
    required this.teacherName,
    required this.teacherPassword,
  }) : super(key: key);

  @override
  _ShowAllStudentState createState() => _ShowAllStudentState(
        className: className,
        classId: classId,
        teacherName: teacherName,
        teacherPassword: teacherPassword,
      );
}

class _ShowAllStudentState extends State<ShowAllStudents> {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  _ShowAllStudentState({
    required this.className,
    required this.classId,
    required this.teacherName,
    required this.teacherPassword,
  });

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentBloc>(context).add(GetAllStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Students"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (con, state) {
            if (state is StudentEmpty) {
              return Center(
                child: Text("There are no students"),
              );
            }
            if (state is AllStudentLoaded) {
              return ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (c, index) {
                  final student = state.students.elementAt(index);
                  return ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${Constants.baseURL}/register/displayImage/${student.studentId}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(student.studentName),
                      ],
                    ),
                    onTap: () {
                      if (this.className == '' || this.teacherPassword == '') {
                        return;
                      }
                      BlocProvider.of<ClassBloc>(context).add(
                        AddStudentToClass(
                          classId: classId,
                          studentId: student.studentId,
                        ),
                      );
                      Navigator.of(context).popAndPushNamed(
                        RouteGenerator.classDetail,
                        arguments: ScreenArguments(
                          classId: classId,
                          className: className,
                          name: this.className,
                          password: this.teacherPassword,
                        ),
                      );
                    },
                  );
                },
              );
            }
            if (state is Error) {
              return Center(
                child: Text("Could not load students"),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "student",
        onPressed: () => {
          Navigator.of(context).popAndPushNamed(
            RouteGenerator.createStudent,
          )
        },
        label: Text("Create Student"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
