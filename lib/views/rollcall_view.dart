// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_routes.dart';
import '../constants/routes.dart';
import '../constants/token.dart';
import '../enums/menu_action.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../utilities/requests/auth_request.dart';

class RollcallSessionsView extends StatefulWidget {
  const RollcallSessionsView({super.key});

  @override
  State<RollcallSessionsView> createState() => _RollcallSessionsViewState();
}

int _sessioncount = 0;
List<dynamic> attendanceDetail = [];

class _RollcallSessionsViewState extends State<RollcallSessionsView> {
  _fetchSessions() async {
    var dio = Dio();
    dynamic sessionList;
    try {
      var response = await dio.get(
        '$url$rollcallApi$currentUserId',
        options: Options(
          headers: {"Authorization": accessToken},
        ),
      );
      if (response.statusCode == 200) {
        sessionList = response.data['rollCallSessions'] as List;
        return sessionList;
      } else {
        await showErrorDialog(context,
            'Fetching Rollcall Sessions Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _sessioncount = 0;
    attendanceDetail.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _sessioncount = 0;
    attendanceDetail.clear;
  }

  @override
  Widget build(BuildContext context) {
    final lessonId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buổi Điểm Danh'),
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
            future: _fetchSessions(),
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
                        final currentLesson =
                            snapshot.data[index]['lesson']['_id'];
                        if (currentLesson == lessonId &&
                            snapshot.data[index]['end'] == true) {
                          _sessioncount = _sessioncount + 1;
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  attendanceRoute,
                                  arguments:
                                      snapshot.data[index]['_id'].toString(),
                                );
                              },
                              title: Text(DateFormat('Buổi dd-MM-yyyy')
                                  .format(DateFormat('EEE LLL d yyyy').parse(
                                      '${snapshot.data[index]['createdAt']}'))
                                  .toString()),
                            ),
                          );
                        } else if ((index == (snapshot.data.length - 1) &&
                                _sessioncount == 0) ||
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
