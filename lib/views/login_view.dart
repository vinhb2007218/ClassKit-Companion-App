import 'package:attendanceappapi/utilities/dialogs/error_dialog.dart';
import 'package:attendanceappapi/utilities/requests/auth_request.dart';
import 'package:flutter/material.dart';
import 'package:attendanceappapi/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _accountEmail;
  late final TextEditingController _password;

  @override
  void initState() {
    _accountEmail = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _accountEmail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _accountEmail,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (_accountEmail.text.isEmpty &&
                            _password.text.isEmpty) {
                          await showErrorDialog(
                              context, 'Xin nhập thông tin tài khoản');
                        } else if (_accountEmail.text.isEmpty) {
                          await showErrorDialog(context, 'Xin nhập email');
                        } else if (_password.text.isEmpty) {
                          await showErrorDialog(context, 'Xin nhập mật khẩu');
                        } else {
                          await loginUser(
                            context,
                            _accountEmail.text,
                            _password.text,
                          );
                        }
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: const Color(0x00ffffff),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 8.0),
          child: Row(
            children: [
              Expanded(
                // width: 310,
                flex: 5,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Đăng ký tài khoản mới',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        settingsRoute,
                      );
                    },
                    child: const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
