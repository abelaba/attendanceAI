import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/arguments/StudentArgument.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/models/student_model.dart';

class ClassDetail extends StatefulWidget {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  const ClassDetail(
      {Key? key,
      required this.className,
      required this.teacherName,
      required this.classId,
      required this.teacherPassword})
      : super(key: key);
  @override
  _ClassDetailState createState() => _ClassDetailState(
      className: className,
      classId: classId,
      teacherName: teacherName,
      teacherPassword: teacherPassword);
}

class _ClassDetailState extends State {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  _ClassDetailState(
      {required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword});

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClassBloc>(context).add(FetchClassDetail(this.classId));
  }

  @override
  Widget build(BuildContext buildCcontext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.className}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(buildCcontext).pop();
          },
        ),
      ),
      body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
        if (state is ClassError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (state is ClassEmpty) {
          return Center(
            child: Text("There is no class selected"),
          );
        }
        if (state is OneClassLoaded) {
          final all_students = state.className.studentsId;
          final all_students_json =
              all_students.map((e) => Student.fromJson(e)).toList();

          return ListView.builder(
              itemCount: all_students.length,
              itemBuilder: (ct, index) {
                return ListTile(
                  title: Text(all_students_json[index].studentName),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => {
                                  Navigator.of(buildCcontext).popAndPushNamed(
                                      RouteGenerator.showStudentDetail,
                                      arguments: new StudentArguments(
                                          id: all_students_json[index]
                                              .studentId,
                                          studentName: all_students_json[index]
                                              .studentName,
                                          imagePath: all_students_json[index]
                                              .imagePath))
                                },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => {
                                  BlocProvider.of<StudentBloc>(context).add(
                                      DeleteStudent(
                                          id: all_students_json[index]
                                              .studentId)),
                                },
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              });
        }
        return Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          BlocProvider.of<StudentBloc>(context).add(GetAllStudents()),
          Navigator.of(buildCcontext).pushNamed(RouteGenerator.showAllStudents,
              arguments: ScreenArguments(
                  classId: classId,
                  className: className,
                  name: this.teacherName,
                  password: this.teacherPassword))
        },
        label: Text("Add Student"),
        icon: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
