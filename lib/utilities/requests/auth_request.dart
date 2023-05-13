// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_routes.dart';
import '../../constants/routes.dart';
import '../../constants/token.dart';
import '../api_models/user.dart';
import '../dialogs/error_dialog.dart';
import '../dialogs/to_login_dialog.dart';
import '../helpers/loading_screen.dart';

Future<User> registerUser(
  BuildContext context,
  String name,
  String account,
  String password,
) async {
  LoadingScreen().show(
    context: context,
    text: 'Đang tạo tài khoản...',
  );
  final response = await http.post(
    Uri.parse('$url$registerApi'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'account': account,
      'password': password,
      'cfPassword': password,
    }),
  );

  if (response.statusCode == 201) {
    LoadingScreen().hide();
    final moveToLogin = await showToLogInDialog(context);
    if (moveToLogin) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(loginRoute, (route) => false);
    }
    return User.fromJson(jsonDecode(response.body));
  } else {
    LoadingScreen().hide();
    await showErrorDialog(context,
        'Registration Failed with status code: ${response.statusCode}');
    throw Exception();
  }
}

Future<User> loginUser(
  BuildContext context,
  String account,
  String password,
) async {
  LoadingScreen().show(
    context: context,
    text: 'Đang đăng nhập...',
  );
  final response = await http.post(
    Uri.parse('$url$loginApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'account': account,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    LoadingScreen().hide();
    Navigator.of(context).pushNamedAndRemoveUntil(
      courseRoute,
      (route) => false,
    );
    final access = jsonDecode(response.body)['access_token'];
    accessToken = access;
    final user = User.fromJson(jsonDecode(response.body)['user']);
    currentUserId = user.userId;
    return user;
  } else {
    LoadingScreen().hide();
    await showErrorDialog(
        context, 'Login Failed with status code: ${response.statusCode}');
    throw Exception();
  }
}

Future<void> logOutUser(BuildContext context) async {
  LoadingScreen().show(
    context: context,
    text: 'Đang đăng xuất...',
  );
  await http.get(Uri.parse('$url$logoutApi'));
  LoadingScreen().hide();
}
