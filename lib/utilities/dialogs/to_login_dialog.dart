import 'package:flutter/material.dart';
import 'package:attendanceappapi/utilities/dialogs/generic_dialog.dart';

Future<bool> showToLogInDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Đăng ký thành công',
    content: 'Chuyển đến trang đăng nhập?',
    optionsBuilder: () => {
      'Không': false,
      'OK': true,
    },
  ).then((value) => value ?? false);
}
