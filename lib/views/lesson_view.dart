// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../constants/api_routes.dart';
import '../constants/routes.dart';
import '../constants/token.dart';
import '../enums/menu_action.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../utilities/requests/auth_request.dart';

class LessonsView extends StatefulWidget {
  const LessonsView({super.key});

  @override
  State<LessonsView> createState() => _LessonsViewState();
}

int _lessoncount = 0;

class _LessonsViewState extends State<LessonsView> {
  _fetchLessons() async {
    var dio = Dio();
    dynamic lessonList;
    try {
      var response = await dio.get(
        '$url$lessonApi',
        options: Options(
          headers: {"Authorization": accessToken},
        ),
      );
      if (response.statusCode == 200) {
        lessonList = response.data['lessons'] as List;
        return lessonList;
      } else {
        await showErrorDialog(context,
            'Fetching Lessons Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    _lessoncount = 0;
    super.initState();
  }

  @override
  void dispose() {
    _lessoncount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buổi Học'),
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
            future: _fetchLessons(),
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
                        final currentCourse =
                            snapshot.data[index]['course']['_id'];
                        if (currentCourse == courseId) {
                          _lessoncount = _lessoncount + 1;
                          Text room;
                          if (snapshot.data[index]['roomLocation'] == '') {
                            room = const Text('Không xác định');
                          } else {
                            room = Text(
                              'Phòng: ${snapshot.data[index]['roomLocation']}',
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            );
                          }

                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  rollcallRoute,
                                  arguments:
                                      snapshot.data[index]['_id'].toString(),
                                );
                              },
                              title: Text('${snapshot.data[index]['weekday']}'),
                              subtitle: room,
                              // Text(
                              //   room,
                              //   style: const TextStyle(
                              //     color: Colors.blue,
                              //   ),
                              // ),
                            ),
                          );
                        } else if ((index == (snapshot.data.length - 1) &&
                                _lessoncount == 0) ||
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
