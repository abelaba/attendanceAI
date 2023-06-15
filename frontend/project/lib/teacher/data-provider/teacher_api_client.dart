import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/teacher/models/models.dart';
import 'package:project/utils/constants.dart';

class TeacherApiClient {
  final http.Client httpClient;
  final url = Constants.baseURL;

  TeacherApiClient({required this.httpClient});
  Future<Teacher> createTeacher(Teacher teacher) async {
    final response = await http.post(
      Uri.parse("$url/createTeacher"),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(
        <String, dynamic>{"name": teacher.name, "password": teacher.password},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Could not create teacher" + response.body);
    }

    return Teacher.fromJson(jsonDecode(response.body));
  }

  Future<Teacher> getTeacher(Teacher teacher) async {
    String username = teacher.name;
    String password = teacher.password;

    try {
      final response = await http.get(
        Uri.parse("$url/getTeacher/$username/$password"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
      );
      if (response.statusCode != 200) {
        throw Exception("Could not find teacher");
      }
      final json = jsonDecode(response.body);
      return Teacher.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Teacher>> getAllTeachers() async {
    final response = await this.httpClient.get(
          Uri.parse("$url/getTeachers"),
        );
    if (response.statusCode != 200) {
      throw Exception("Could not found teachers");
    }
    final json = jsonDecode(response.body) as List;
    print(json);
    return json.map((teacher) => Teacher.fromJson(teacher)).toList();
  }

  Future<void> updateTeacher(
      String oldName, String newName, String password) async {
    final http.Response response = await httpClient.put(
        Uri.parse("$url/updateTeacher"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          'old-name': oldName,
          'new-name': newName,
          'old-password': password
        }));
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Failed to update Teacher");
    }
  }

  Future<void> deleteTeacher(Teacher teacher) async {
    final http.Response response =
        await httpClient.delete(Uri.parse("$url/deleteTeacher/1"),
            headers: {
              "Content-type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(<String, dynamic>{'name': teacher.name}));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete Teacher");
    }
  }
}
