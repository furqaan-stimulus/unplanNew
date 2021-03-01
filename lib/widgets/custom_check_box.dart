import 'package:flutter/material.dart';
import 'package:unplan/utils/view_color.dart';

class CustomCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: ViewColor.background_white_color,
        border: Border.all(color: ViewColor.text_black_variant_color, width: 1),
      ),
    );
  }
}
