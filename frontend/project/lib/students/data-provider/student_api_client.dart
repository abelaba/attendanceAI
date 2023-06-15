import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:project/class/models/class_model.dart';
import 'package:project/students/models/student_model.dart';
import 'package:project/teacher/models/Teachers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class StudentApiClient {
  final http.Client httpClient;

  final url = 'http://192.168.8.100:3000';

  StudentApiClient({required this.httpClient});
  Future<Student> createStudent(String name, XFile image) async {
    var request =
        new http.MultipartRequest("POST", Uri.parse("$url/createStudent"));

    var file = await http.MultipartFile.fromPath("file", image.path,
        filename: 'filename', contentType: new MediaType('image', 'jpeg'));

    request.fields["name"] = name;

    request.files.add(file);

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final json = jsonDecode(respStr);
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

  Future<void> addImage(int studentId, XFile studentImage) async {
    var request = new http.MultipartRequest(
        "PUT", Uri.parse("$url/register/addImage/$studentId"));

    var file = await http.MultipartFile.fromPath("file", studentImage.path,
        filename: 'filename', contentType: new MediaType('image', 'jpeg'));

    request.files.add(file);

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

  Future<void> deleteStudent(int id) async {
    final response =
        await httpClient.delete(Uri.parse("$url/deleteStudent/$id"));
    if (response.statusCode != 200) {
      throw Exception("Could not delete data because" + response.body);
    }
  }
}
