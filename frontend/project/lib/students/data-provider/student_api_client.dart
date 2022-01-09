import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:project/class/models/class_model.dart';
import 'package:project/students/models/student_models.dart';
import 'package:project/teacher/models/Teachers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class StudentApiClient {
  final http.Client httpClient;

  final url = 'http://192.168.1.10:3000';

  StudentApiClient({required this.httpClient});
  Future<Student> createStudent(String name) async {
    final response = await this.httpClient.post(Uri.parse("$url/createStudent"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"name": name}));
    if (response.statusCode != 200) {
      throw Exception("COuld not create student");
    }
    final json = jsonDecode(response.body);
    print(json);
    return Student.fromJson(json);
  }

  Future<Student> updateStudent(int id, String studentName) async {
    final response =
        await this.httpClient.put(Uri.parse("$url/updateStudent/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{"name": studentName}));
    if (response.statusCode != 200) {
      throw Exception("could not update student do to " + response.body);
    }
    final json = jsonDecode(response.body);
    return Student.fromJson(json);
  }

  Future<void> addImage(int studentId, List<int> studentImage) async {
    var request = new http.MultipartRequest(
        "PUT", Uri.parse("$url/register/addImage/$studentId"));
    request.files.add(await http.MultipartFile.fromBytes('file', studentImage,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "a"));
    var req = request.send();

  }

  Future<List<Student>> getStudents() async {
    final response = await this.httpClient.get(
          Uri.parse("$url/getStudents"),
        );
    if (response.statusCode != 200) {
      throw FormatException("Could not get students due to ", response.body);
    }
    final json = jsonDecode(response.body) as List;
    return json.map((st) => Student.fromJson(st)).toList();
  }
}
