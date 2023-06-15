import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/class/models/class_model.dart';
import 'package:project/routes.dart';

class ShowClasses extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const ShowClasses({
    Key? key,
    required this.teacherName,
    required this.teacherPassword,
  }) : super(key: key);

  @override
  _ShowClassesState createState() => _ShowClassesState(
        teacherName: teacherName,
        teacherPassword: teacherPassword,
      );
}

class _ShowClassesState extends State<ShowClasses> {
  final String teacherName;
  final String teacherPassword;
  late TextEditingController _searchController;

  _ShowClassesState({
    required this.teacherName,
    required this.teacherPassword,
  });

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClassBloc>(context).add(FetchAllClasses(
      teacherName: teacherName,
      teacherPassword: teacherPassword,
    ));

    _searchController = TextEditingController();
  }

  List<ClassModel> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Classes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
        if (state is ClassIsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ClassError) {
          return Center(
            child: Text("Error finding class"),
          );
        } else if (state is AllClassesLoaded) {
          final allclassNames = state.classNames.toList();

          if (_searchController.text.isNotEmpty) {
            _searchResults = allclassNames
                .where((classInfo) =>
                    classInfo.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    classInfo.classNameId
                        .toString()
                        .contains(_searchController.text))
                .toList();
          } else {
            _searchResults = allclassNames;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (c, index) {
                    return ListTile(
                      title: Text(_searchResults.elementAt(index).name),
                      onTap: () {
                        Navigator.of(buildContext).popAndPushNamed(
                          RouteGenerator.classDetail,
                          arguments: ScreenArguments(
                            classId:
                                _searchResults.elementAt(index).classNameId,
                            className: _searchResults.elementAt(index).name,
                            name: this.teacherName,
                            password: this.teacherPassword,
                          ),
                        );
                      },
                      trailing: TextButton(
                        onPressed: () => {
                          BlocProvider.of<ClassBloc>(context).add(
                            DeleteClass(
                              id: _searchResults.elementAt(index).classNameId,
                              teacherName: teacherName,
                              teacherPassword: teacherPassword,
                            ),
                          ),
                        },
                        child: Icon(Icons.delete),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text("No classes found"),
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.of(buildContext).popAndPushNamed(
            RouteGenerator.createClass,
            arguments: ScreenArguments(
              classId: 0,
              className: "",
              name: this.teacherName,
              password: this.teacherPassword,
            ),
          )
        },
        label: Text("Create Class"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
