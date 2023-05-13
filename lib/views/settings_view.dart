// ignore_for_file: use_build_context_synchronously

import 'package:attendanceappapi/utilities/dialogs/save_confirm_dialog.dart';
import 'package:attendanceappapi/utilities/helpers/loading_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_routes.dart';
import '../constants/routes.dart';
import '../constants/token.dart';
import '../utilities/dialogs/error_dialog.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _initFlag = 0;
  String initialurl = url;
  String customurl = url;
  late final TextEditingController _customUrl;
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
    _customUrl = TextEditingController();
    _initFlag = 0;
    super.initState();
  }

  @override
  void dispose() {
    _customUrl.dispose();
    _initFlag = 0;
    super.dispose();
  }

  final List<String> urlSelection = [
    'https://auto-attend.onrender.com',
    'https://auto-attend-api.onrender.com'
  ];
  final List<bool> isSelected = [false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chọn một trong hai API: ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ToggleButtons(
                      fillColor: Colors.blue,
                      selectedBorderColor: Colors.blue,
                      selectedColor: Colors.white,
                      color: Colors.blue,
                      borderColor: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                      borderWidth: 2.0,
                      direction: Axis.vertical,
                      isSelected: isSelected,
                      onPressed: (int index) {
                        setState(() {
                          _customUrl.clear();
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] =
                                  !isSelected[buttonIndex];
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      children: const <Text>[
                        Text(
                          'Production',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Testing',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hoặc một API khác: ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onTap: () {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          isSelected[buttonIndex] = false;
                        }
                      });
                    },
                    controller: _customUrl,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'http://url.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
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
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                // LoadingScreen()
                //     .show(context: context, text: 'Đang Lưu Cài Đặt...');
                if (_customUrl.text.isEmpty) {
                  for (int index = 0; index < isSelected.length; index++) {
                    if (isSelected[index] == true) {
                      customurl = urlSelection[index];
                    }
                  }
                } else {
                  customurl = _customUrl.text;
                }
                if (initialurl != customurl) {
                  var shouldSave = await saveConfirmDialog(context);
                  if (shouldSave) {
                    LoadingScreen()
                        .show(context: context, text: 'Đang Lưu Cài Đặt...');
                    url = customurl;
                    await wakeupCall();
                    LoadingScreen().hide();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Lưu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
