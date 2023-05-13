import 'package:flutter/material.dart';
import 'package:attendanceappapi/utilities/dialogs/generic_dialog.dart';

Future<bool> showStatisticDialog(
  BuildContext context,
  int absent,
) {
  return showGenericDialog(
    context: context,
    title: 'Thống kê sỉ số',
    content: 'Buổi điểm danh có $absent sinh viên vắng',
    optionsBuilder: () => {
      'OK': true,
    },
  ).then((value) => value ?? false);
}
