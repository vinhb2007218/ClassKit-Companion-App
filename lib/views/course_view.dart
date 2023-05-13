// ignore_for_file: use_build_context_synchronously

import 'package:attendanceappapi/constants/api_routes.dart';
import 'package:attendanceappapi/constants/routes.dart';
import 'package:attendanceappapi/constants/token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../enums/menu_action.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../utilities/requests/auth_request.dart';

class CourseListView extends StatefulWidget {
  const CourseListView({super.key});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

int _coursecount = 0;

class _CourseListViewState extends State<CourseListView> {
  _fetchCourses() async {
    var dio = Dio();
    dynamic courseList;
    try {
      var response = await dio.get(
        '$url$courseApi',
        options: Options(
          headers: {"Authorization": accessToken},
        ),
      );
      if (response.statusCode == 200) {
        courseList = response.data['courses'] as List;
        return courseList;
      } else {
        await showErrorDialog(context,
            'Fetching Courses Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _coursecount = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _coursecount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học Phần'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await logOutUser(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Đăng Xuất'),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: _fetchCourses(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasData && snapshot.data.length != 0) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final currentUser =
                            snapshot.data[index]['teacher']['_id'];
                        if (currentUser == currentUserId) {
                          _coursecount = _coursecount + 1;
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  lessonViewRoute,
                                  arguments:
                                      snapshot.data[index]['_id'].toString(),
                                );
                              },
                              title: Text(
                                  '${snapshot.data[index]['courseCode']} ${snapshot.data[index]['name']}'),
                              subtitle: Text(
                                  'Học kỳ ${snapshot.data[index]['semester']}, năm học ${snapshot.data[index]['yearStart']}-${snapshot.data[index]['yearEnd']}'),
                            ),
                          );
                        } else if ((index == (snapshot.data.length - 1) &&
                                _coursecount == 0) ||
                            snapshot.data.length == 0) {
                          return Column(
                            children: const [
                              SizedBox(
                                height: 100,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.search_off_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Chưa có dữ liệu cho trang này',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                      itemCount: snapshot.data.length,
                    );
                  } else if (snapshot.data.length == 0) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 100,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.search_off_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Chưa có dữ liệu cho trang này',
                            style: TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            }),
      ),
    );
  }
}
