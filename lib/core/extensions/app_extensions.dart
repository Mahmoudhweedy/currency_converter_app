import 'package:flutter/material.dart';

SizedBox verticalSpace(double height) => SizedBox(
      height: height,
    );

SizedBox horizontalSpace(double width) => SizedBox(
      width: width,
    );

extension NavigatorExtensions on BuildContext {
  void pop() {
    Navigator.of(this).pop();
  }
}
