import 'package:attendanceappapi/utilities/dialogs/error_dialog.dart';
import 'package:attendanceappapi/utilities/requests/auth_request.dart';
import 'package:flutter/material.dart';
import 'package:attendanceappapi/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _userName;
  late final TextEditingController _accountEmail;
  late final TextEditingController _password;
  late final TextEditingController _cfPassword;

  @override
  void initState() {
    _userName = TextEditingController();
    _accountEmail = TextEditingController();
    _password = TextEditingController();
    _cfPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
    _accountEmail.dispose();
    _password.dispose();
    _cfPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký'),
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
                    controller: _userName,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nhập username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _accountEmail,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nhập email',
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
                      hintText: 'Nhập mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _cfPassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Xác nhận mật khẩu',
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
                        if (_userName.text.isEmpty ||
                            _accountEmail.text.isEmpty ||
                            _password.text.isEmpty ||
                            _cfPassword.text.isEmpty) {
                          await showErrorDialog(
                              context, 'Xin nhập đầy đủ thông tin');
                        } else if (_password.text != _cfPassword.text) {
                          await showErrorDialog(
                              context, 'Xin kiểm tra và xác nhận lại mật khẩu');
                        } else {
                          await registerUser(
                            context,
                            _userName.text,
                            _accountEmail.text,
                            _password.text,
                          );
                        }
                      },
                      child: const Text(
                        'Đăng ký',
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
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(width: 2.0, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Đăng nhập tài khoản đã tạo',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
