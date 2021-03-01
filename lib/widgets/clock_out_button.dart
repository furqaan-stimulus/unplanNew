import 'package:flutter/material.dart';
import 'package:unplan/enum/log_type.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class ClockOutButton extends StatefulWidget {
  final LogType type;
  final bool pressed;
  final bool firstLog;
  final Function() onPressed;

  const ClockOutButton({Key key, this.type, this.pressed, this.firstLog, this.onPressed}) : super(key: key);

  @override
  _ClockOutButtonState createState() => _ClockOutButtonState();
}

class _ClockOutButtonState extends State<ClockOutButton> {
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
          Utils.buttonSignOff,
          style: TextStyles.buttonTextStyle1,
        ),
        textColor: Colors.white,
        padding: EdgeInsets.all(16),
        onPressed: widget.pressed
            ? () {}
            : () {
                widget.onPressed();
              },
        color: ViewColor.button_green_color,
      ),
    );
  }
}
