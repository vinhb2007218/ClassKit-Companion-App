import 'package:attendanceappapi/utilities/dialogs/error_dialog.dart';
import 'package:attendanceappapi/views/lesson_view.dart';
import 'package:attendanceappapi/views/rollcall_view.dart';
import 'package:attendanceappapi/views/settings_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:attendanceappapi/constants/routes.dart';
import 'package:attendanceappapi/views/login_view.dart';
import 'package:attendanceappapi/views/register_view.dart';
import 'constants/api_routes.dart';
import 'constants/token.dart';
import 'views/attendance_view.dart';
import 'views/course_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomepageView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        attendanceRoute: (context) => const AttendanceView(),
        courseRoute: (context) => const CourseListView(),
        lessonViewRoute: (context) => const LessonsView(),
        rollcallRoute: (context) => const RollcallSessionsView(),
        settingsRoute: (context) => const SettingsView(),
      },
    ),
  );
}

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  int _initFlag = 0;
  Future wakeupCall() async {
    var dio = Dio();
    while (_initFlag == 0) {
      try {
        final response = await dio.get('$url$wakeupApi');
        if (response.statusCode == 200) {
          _initFlag == 200;
          return;
        }
      } catch (e) {
        await showErrorDialog(
          context,
          'Something Unexpected Happened: $e',
        );
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initFlag = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _initFlag = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: wakeupCall(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return const LoginView();
            default:
              return const InitialView();
          }
        },
      ),
    );
  }
}

class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Đang Tải...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
