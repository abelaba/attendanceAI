import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/class/models/class_model.dart';

class ClassApiClient {
  final http.Client httpClient;
  final url = 'http://192.168.8.100:3000';
  const ClassApiClient({required this.httpClient});
  Future<ClassModel> getClassDetail(int id) async {
    final response =
        await this.httpClient.get(Uri.parse("$url/getClassDetail/$id"));
    if (response.statusCode != 200) {
      print(response.body);
    }
    final json = jsonDecode(response.body);
    print(json);
    return ClassModel.fromJson(json);
  }

  Future<List<ClassModel>> getClasses(String name, String password) async {
    final response =
        await this.httpClient.get(Uri.parse("$url/getClasses/$name/$password"));
    if (response.statusCode != 200) {
      print(response.body);
    }
    final json = jsonDecode(response.body) as List;
    return json.map((className) => ClassModel.fromJson(className)).toList();
  }

  Future<ClassModel> createClassName(
      String className, String teacherName, String teacherpPassword) async {
    final response = await httpClient.post(Uri.parse("$url/createClass"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "teacher-name": teacherName,
          "teacher-password": teacherpPassword,
          "class-name": className
        }));
    if (response.statusCode != 200) {
      throw Exception("Could not create class Name due to" + response.body);
    }
    final json = jsonDecode(response.body);
    print(json);
    return ClassModel.fromJson(json);
  }

  Future<void> addStudent(int classId, int studentId) async {
    final response =
        await httpClient.post(Uri.parse("$url/register/addStudent/$classId"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{"student-id": studentId}));
    if (response.statusCode != 200) {
      throw Exception("Could not add student due to " + response.body);
    }
  }

  Future<void> deleteClass(int id) async {
    final response = await httpClient.delete(Uri.parse("$url/deleteClass/$id"));
    if (response.statusCode != 200) {
      throw Exception("Could not delete data because" + response.body);
    }
  }
}
