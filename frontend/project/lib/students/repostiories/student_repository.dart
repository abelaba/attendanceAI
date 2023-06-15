import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/students/models/student_model.dart';
import 'package:project/students/data-provider/student_api_client.dart';

class StudentRepository {
  final StudentApiClient studentApiClient;

  StudentRepository({required this.studentApiClient});
  Future<Student> createStudent(String name, XFile image) async {
    return await studentApiClient.createStudent(name, image);
  }

  Future<Student> updateStudent(int id, String studentName) async {
    return await studentApiClient.updateStudent(id, studentName);
  }

  Future<void> addImageStudent(int studentId, XFile studentImage) async {
    return await studentApiClient.addImage(studentId, studentImage);
  }

  Future<List<Student>> getStudents() async {
    return await studentApiClient.getStudents();
  }

  Future<void> deleteStudent(int id) async {
    return await studentApiClient.deleteStudent(id);
  }
}
