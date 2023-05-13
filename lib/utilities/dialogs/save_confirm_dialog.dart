import 'package:attendanceappapi/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> saveConfirmDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Xác nhận thay đổi',
    content: 'Lưu những cài đặt đã thay đổi?',
    optionsBuilder: () => {
      'Hủy': false,
      'Lưu': true,
    },
  ).then((value) => value ?? false);
}
