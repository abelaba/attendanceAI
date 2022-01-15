import 'package:project/class/models/class_model.dart';
import 'package:project/class/data-provider/class_api_client.dart';

class ClassRepostiry {
  final ClassApiClient classApiClient;

  ClassRepostiry({required this.classApiClient});

  Future<ClassModel> getClassDetail(int id) async {
    return await classApiClient.getClassDetail(id);
  }

  Future<List<ClassModel>> getClasses(String name, String password) async {
    return await classApiClient.getClasses(name, password);
  }

  Future<void> addStudent(int classId, int studentId) async {
    return await classApiClient.addStudent(classId, studentId);
  }

  Future<void> deleteClass(int id) async {
    return await classApiClient.deleteClass(id);
  }
}
