import 'package:flutter/material.dart';
import 'package:unplan/utils/view_color.dart';

class TextStyles {
  TextStyles._();

  static const KFontFam = 'Mulish';
  static const _kFontPkg = null;

  static const TextStyle splashTitle1 = TextStyle(
      fontFamily: KFontFam,
      package: _kFontPkg,
      fontStyle: FontStyle.normal,
      fontSize: 36,
      color: ViewColor.text_white_color);

  static const TextStyle loginFooterTitle1 = TextStyle(
      fontFamily: KFontFam,
      package: _kFontPkg,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 36,
      color: ViewColor.button_green_color);

  static const TextStyle splashTitle2 = TextStyle(
      fontFamily: KFontFam,
      package: _kFontPkg,
      fontStyle: FontStyle.normal,
      fontSize: 36,
      color: ViewColor.button_green_color);

  static const TextStyle splashSubTitle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontSize: 18,
    // fontWeight: FontWeight.w600,
    letterSpacing: 0.65,
    color: ViewColor.button_grey_color,
  );

  static const TextStyle loginFooterSubTitle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.65,
    fontWeight: FontWeight.w600,
    color: ViewColor.text_grey_footer_color,
  );

  static const TextStyle loginTitle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 36,
    color: ViewColor.background_purple_color,
  );

  static const TextStyle emailTextStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.65,
    color: ViewColor.text_black_color,
  );

  static const TextStyle emailHintStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.65,
    color: ViewColor.text_grey_footer_color,
  );

  static const TextStyle passwordTextStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.65,
    color: ViewColor.text_black_color,
  );
  static const TextStyle passwordHintStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.65,
    color: ViewColor.text_grey_footer_color,
  );

  // employee login button text
  static const TextStyle buttonTextStyle1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    letterSpacing: 0.5,
    color: ViewColor.background_purple_color,
  );

  // clock in-out button text
  static const TextStyle buttonTextStyle2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    fontSize: 20,
    color: ViewColor.text_black_color,
  );

  static const TextStyle bottomTextStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.5,
    color: ViewColor.button_green_color,
  );

  static const TextStyle bottomTextStyle2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_grey_footer_color,
  );

  static const TextStyle bottomTextStyle3 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_green_color,
  );

  static const TextStyle alertTextStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_pink_color,
  );

  static const TextStyle alertTextStyle1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_red_color,
  );

  // notification text
  static const TextStyle notificationTextStyle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_white_color,
  );

  static const TextStyle notificationTextStyle1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_pink_color,
  );

  static const TextStyle homeTitle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontSize: 30,
    color: ViewColor.background_purple_color,
  );

  static const TextStyle homeSubTitle = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontSize: 18,
    color: ViewColor.background_purple_color,
  );

  static const TextStyle homeText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.text_white_color,
  );

  static const TextStyle homeText1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 0.65,
    color: ViewColor.button_green_color,
  );

  static const TextStyle homeText2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: 0.5,
    color: ViewColor.button_green_color,
  );
  static const TextStyle bottomButtonText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.65,
    fontSize: 20,
    color: ViewColor.button_green_color,
  );

  static const TextStyle homeBottomText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    // fontWeight: FontWeight.w600,
    fontSize: 24,
    color: ViewColor.background_purple_color,
  );

  static const TextStyle drawerFooterText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: ViewColor.text_grey_drawer_footer_color,
  );

  static const TextStyle personalPageText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 24,
    color: ViewColor.text_green_2_color,
  );

  static const TextStyle personalPageText2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ViewColor.text_black_variant_color,
  );

  static const TextStyle personalPageText3 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: ViewColor.text_black_variant_color,
  );

  static const TextStyle personalPageText4 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: ViewColor.text_pink_color,
  );
  static const TextStyle personalPageText5 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: ViewColor.text_grey_drawer_footer_color,
  );

  static const TextStyle leaveText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.5,
    color: ViewColor.text_grey_drawer_footer_color,
  );
  static const TextStyle leaveText1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.5,
    color: ViewColor.text_white_color,
  );

  static const TextStyle leaveText2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    color: ViewColor.background_purple_color,
  );

  static const TextStyle leaveText3 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.5,
    color: ViewColor.text_grey_footer_color,
  );

  static const TextStyle leaveText4 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.65,
    color: ViewColor.text_black_color,
  );

  static const TextStyle leaveListText = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 13,
    color: ViewColor.text_black_variant_color,
  );

  static const TextStyle leaveListText1 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 11,
    color: ViewColor.text_green_2_color,
  );

  static const TextStyle leaveListText2 = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 11,
    color: ViewColor.text_red_color,
  );

  static const TextStyle leaveMessages = TextStyle(
    fontFamily: KFontFam,
    package: _kFontPkg,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 13,
    color: ViewColor.text_pink_color,
  );
}
