import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class StudentEvent extends Equatable {}

class CreateStudent extends StudentEvent {
  final String name;
  final XFile image;

  CreateStudent({required this.name, required this.image});
  @override
  List<Object?> get props => [];
}

class UpdateStudent extends StudentEvent {
  final String studentName;
  final int id;

  UpdateStudent({required this.studentName, required this.id});
  @override
  List<Object?> get props => [studentName, id];
}

class AddImageToStudent extends StudentEvent {
  XFile studentImage;
  int studentId;
  AddImageToStudent({required this.studentId, required this.studentImage});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllStudents extends StudentEvent {
  @override
  List<Object?> get props => [];
}

class DeleteStudent extends StudentEvent {
  int id;
  DeleteStudent({required this.id});
  @override
  List<Object?> get props => [this.id];
}
