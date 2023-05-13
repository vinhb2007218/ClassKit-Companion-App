import 'package:flutter/material.dart';
import 'package:attendanceappapi/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Lỗi',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
