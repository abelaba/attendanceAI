import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project/arguments/AttendanceArgument.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/arguments/StudentArgument.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/models/class_model.dart';
import 'package:project/presentation/ClassDetail.dart';
import 'package:project/presentation/CreateClass.dart';
import 'package:project/presentation/CreateStudent.dart';
import 'package:project/presentation/ShowAllStudents.dart';
import 'package:project/presentation/ShowStudentDetail.dart';
import 'package:project/presentation/TakeAttendanceForm.dart';
import 'package:project/presentation/ShowClassAttendance.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'presentation/presentation.dart';

class RouteGenerator {
  static const loginPage = "/";
  static const otherPage = "/other";
  static const singupPage = "/signup";
  static const takeAttendance = "/takeAttendance";
  static const showClasses = "/showClasses";
  static const showAllAttendace = "/showAllAttendance";
  static const showUserSettings = "/showUserSettings";
  static const createClass = "/createClass";
  static const classDetail = "/classDetail";
  static const createStudent = "/createStudent";
  static const showStudentDetail = "/showStudentDetails";
  static const showAllStudents = "/showAllStudents";
  static const takeAttendanceFrom = "/takeAttendanceForm";
  static const showClassAttendance = "/showAttendance";

  RouteGenerator._();
  static Route<dynamic> routegenerator(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case otherPage:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => HomePage(
                  teacherName: args.name,
                  teacherPassword: args.password,
                ));
      case singupPage:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      case takeAttendance:
        final args = settings.arguments as ScreenArguments;

        return MaterialPageRoute(
            builder: (context) => TakeAttendance(
                className: args.className,
                classId: args.classId,
                teacherName: args.name,
                teacherPassword: args.password));
      case showClasses:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => ShowClasses(
                  teacherName: args.name,
                  teacherPassword: args.password,
                ));
      case showAllAttendace:
        return MaterialPageRoute(builder: (context) => ShowAllAttendance());
      case showUserSettings:
        final args = settings.arguments as ScreenArguments;

        return MaterialPageRoute(
            builder: (context) => ShowUserSettings(
                teacherName: args.name, teacherPassword: args.password));
      case createClass:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => CreateClass(
                  teacherName: args.name,
                  teacherPassword: args.password,
                ));
      case classDetail:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => ClassDetail(
                classId: args.classId,
                className: args.className,
                teacherName: args.name,
                teacherPassword: args.password));
      case createStudent:
        return MaterialPageRoute(builder: (context) => CreateStudentWidget());
      case showStudentDetail:
        final args = settings.arguments as StudentArguments;
        return MaterialPageRoute(
            builder: (context) => ShowStudentDetail(
                  studentName: args.studentName,
                  imagePath: args.imagePath,
                  id: args.id,
                ));
      case showAllStudents:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => ShowAllStudents(
                className: args.className,
                classId: args.classId,
                teacherName: args.name,
                teacherPassword: args.password));
      case takeAttendanceFrom:
        final args = settings.arguments as AttendanceArgument;
        return MaterialPageRoute(
            builder: (context) => TakeAttendanceForm(classId: args.classId));
      case showClassAttendance:
        return MaterialPageRoute(builder: (context) => ShowClassAttendance());
      default:
        throw FormatException("Could not find route");
    }
  }
}
