import 'package:flutter/material.dart';

SnackBar mySnackBar({required String msg, required Color bgColor}) {
  return SnackBar(
    content: Text(msg),
    behavior: SnackBarBehavior.floating,
    backgroundColor: bgColor,
  );
}
