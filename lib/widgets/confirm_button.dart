import 'package:flutter/material.dart';
import 'package:unplan/enum/log_type.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class ConfirmButton extends StatefulWidget {
  final LogType type;
  final bool pressed;
  final bool firstLog;
  final Function() onPressed;

  const ConfirmButton({Key key, this.type, this.pressed, this.firstLog, this.onPressed}) : super(key: key);

  @override
  _ConfirmButtonState createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Text(
            Utils.buttonConfirm,
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
      ),
    );
  }
}
