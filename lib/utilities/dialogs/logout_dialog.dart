import 'package:flutter/material.dart';
import 'package:attendanceappapi/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Xác nhận đăng xuất',
    content: 'Kết thúc phiên đăng nhập?',
    optionsBuilder: () => {
      'Hủy': false,
      'Đăng xuất': true,
    },
  ).then((value) => value ?? false);
}
