import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/ui/views/drawer/drawer_view_model.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  String modelName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.nonReactive(
      viewModelBuilder: () => DrawerViewModel(),
      onModelReady: (model) async {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          setState(() {
            modelName = androidInfo.model;
          });
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          setState(() {
            modelName = iosInfo.model;
          });
        }
      },
      builder: (context, model, child) {
        return Drawer(
          child: ListView(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset("assets/svg/cancel.svg"),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: model.getName(),
                        builder: (context, snapshot) {
                          return RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: Utils.HI, style: TextStyles.homeTitle),
                                snapshot.hasData
                                    ? TextSpan(text: '${snapshot.data}', style: TextStyles.homeTitle)
                                    : TextSpan(text: ''),
                                TextSpan(text: Utils.COMMA, style: TextStyles.homeTitle),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          model.navigateToPersonalInfoView();
                        },
                        child: Text(
                          Utils.drawerText,
                          style: TextStyles.homeBottomText,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          model.navigateToEmployeeInfoView();
                        },
                        child: Text(
                          Utils.drawerText1,
                          style: TextStyles.homeBottomText,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          model.navigateToLeavesView();
                        },
                        child: Text(
                          Utils.drawerText2,
                          style: TextStyles.homeBottomText,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          model.navigateToLeavesListView();
                        },
                        child: Text(
                          Utils.drawerText3,
                          style: TextStyles.homeBottomText,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 7.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "device: ", style: TextStyles.drawerFooterText),
                          TextSpan(text: modelName, style: TextStyles.drawerFooterText),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
