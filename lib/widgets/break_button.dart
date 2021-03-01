

import 'package:flutter/material.dart';
import 'package:unplan/enum/log_type.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class BreakButton extends StatefulWidget {
  final LogType type;
  final bool pressed;
  final bool firstLog;
  final Function() onPressed;

  const BreakButton({Key key, this.type, this.pressed, this.firstLog, this.onPressed}) : super(key: key);

  @override
  _BreakButtonState createState() => _BreakButtonState();
}

class _BreakButtonState extends State<BreakButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      width: 160,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          Utils.buttonBreak,
          style: TextStyles.bottomButtonText,
        ),
        textColor: Colors.white,
        padding: EdgeInsets.all(16),
        onPressed: widget.pressed
            ? () {}
            : () {
          widget.onPressed();
        },
        color: ViewColor.background_purple_color,
      ),
    );
  }
}
