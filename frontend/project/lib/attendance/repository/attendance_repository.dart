import 'package:project/attendance/model/attendance_model.dart';
import 'package:project/attendance/data-provider/attendance_api_client.dart';

class AttendanceRepository {
  final AttendanceApiClient attendanceApiClient;

  AttendanceRepository({required this.attendanceApiClient});
  Future<Attendance> takeAttendance(
      int classId, List<int> attendanceImage) async {
    return await attendanceApiClient.takeAttendance(classId, attendanceImage);
  }
}
