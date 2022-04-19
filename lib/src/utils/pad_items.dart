import 'package:flutter/material.dart';

extension ExtendPadding on Widget {
  Widget padTop(double val) {
    return Padding(
      padding: EdgeInsets.only(top: val),
      child: this,
    );
  }

  Widget padHorizontal(double val) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: val),
      child: this,
    );
  }

  Widget padVertical(double val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: val),
      child: this,
    );
  }

  Widget padLeft(double val) {
    return Padding(
      padding: EdgeInsets.only(left: val),
      child: this,
    );
  }

  Widget formPadding() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: this,
    );
  }
}
