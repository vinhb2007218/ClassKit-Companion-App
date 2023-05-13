// ignore_for_file: use_build_context_synchronously

import 'package:attendanceappapi/utilities/dialogs/statistic_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_routes.dart';
import '../constants/routes.dart';
import '../constants/token.dart';
import '../enums/menu_action.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../utilities/requests/auth_request.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  int _absentcount = 0;
  int _attendancecount = 0;

  List<dynamic> attendanceDetail = [];
  void _absentCount(String idsession) {
    int absent = 0;
    for (var i = 0; i < attendanceDetail.length; i++) {
      if (attendanceDetail[i]['rollCallSession'] == idsession) {
        if (attendanceDetail[i]['absent']) {
          absent++;
        }
      }
    }

    _absentcount = absent;
  }

  String _parseAbsent(String absent) {
    if (absent == 'true') {
      return 'Vắng';
    } else {
      return '';
    }
  }

  _fetchAttendance(String sessionId) async {
    var dio = Dio();
    List<dynamic> sessions;
    List<dynamic> attendanceList = [];
    List<dynamic> result = [];
    try {
      var response = await dio.get(
        '$url$rollcallApi$currentUserId',
        options: Options(
          headers: {"Authorization": accessToken},
        ),
      );
      if (response.statusCode == 200) {
        sessions = response.data['rollCallSessions'] as List;
        // ignore: avoid_function_literals_in_foreach_calls
        sessions.forEach((element) {
          Map obj = element;
          List attendanceDetail = obj['attendanceDetails'];
          if (attendanceDetail.isNotEmpty) {
            attendanceList.add(attendanceDetail);
          }
        });
        for (var i = 0; i < attendanceList.length; i++) {
          for (var j = 0; j < attendanceList[i].length; j++) {
            if (attendanceList[i][j]['rollCallSession'] == sessionId) {
              result.add(attendanceList[i][j]);
            }
          }
        }
        attendanceDetail = result;
        return result;
      } else {
        await showErrorDialog(context,
            'Fetching Attendance Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _absentcount = 0;
    _attendancecount = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _absentcount = 0;
    _attendancecount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sinh Viên'),
        actions: [
          PopupMenuButton<MenuActionSV>(
            onSelected: (value) async {
              switch (value) {
                case MenuActionSV.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await logOutUser(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
                case MenuActionSV.stat:
                  await showStatisticDialog(context, _absentcount);
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActionSV>(
                  value: MenuActionSV.logout,
                  child: Text('Đăng Xuất'),
                ),
                PopupMenuItem<MenuActionSV>(
                  value: MenuActionSV.stat,
                  child: Text('Thống Kê'),
                )
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: _fetchAttendance(sessionId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  _absentCount(sessionId);
                  if (snapshot.hasData && snapshot.data.length != 0) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final currentSession =
                            snapshot.data[index]['rollCallSession'];
                        if (currentSession == sessionId) {
                          _attendancecount = _attendancecount + 1;

                          return Card(
                            child: ListTile(
                              title: Text(
                                  '${index + 1}. ${snapshot.data[index]['student']['name']}'),
                              subtitle: Text(
                                  '${snapshot.data[index]['student']['studentCode']}'),
                              trailing: Text(
                                _parseAbsent(
                                    snapshot.data[index]['absent'].toString()),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else if (index == (snapshot.data.length - 1) &&
                            _attendancecount == 0) {
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
