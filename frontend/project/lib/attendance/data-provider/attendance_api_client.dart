import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:project/attendance/model/attendance_model.dart';

class AttendanceApiClient {
  final http.Client httpClient;
  final url = 'http://192.168.1.10:3000';
  AttendanceApiClient({required this.httpClient});

  Future<Attendance> takeAttendance(
      int classId, List<int> attendanceImage) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse("$url/attend/takeAttendance/$classId"));
    print("start");
    request.files.add(await http.MultipartFile.fromBytes(
        'file', attendanceImage,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "a"));
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final json = jsonDecode(respStr);
    return Attendance.fromJson(json);
  }
}
