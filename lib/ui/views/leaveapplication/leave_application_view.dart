import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/model/employee_information.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/leaveapplication/leave_application_view_model.dart';
import 'package:unplan/ui/views/leaveform/leave_form_view.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class LeaveApplicationView extends StatefulWidget {
  @override
  _LeaveApplicationViewState createState() => _LeaveApplicationViewState();
}

class _LeaveApplicationViewState extends State<LeaveApplicationView> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  List<EmployeeInformation> empList = [];

  @override
  void initState() {
    super.initState();
    getEmpInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaveApplicationViewModel>.nonReactive(
      viewModelBuilder: () => LeaveApplicationViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ViewColor.background_white_color,
          key: _scaffoldState,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 70.0, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          "assets/svg/hamburger.svg",
                          width: 40,
                        ),
                        onTap: () {
                          _scaffoldState.currentState.openDrawer();
                        },
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            model.navigateTOHomeView();
                          },
                          child: SvgPicture.asset("assets/svg/cancel.svg"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                    height: 20,
                  ),
                  Text(
                    'leave balance',
                    style: TextStyles.personalPageText,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ViewColor.text_grey_footer_color,
                        ),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                Utils.statSub4,
                                style: TextStyles.leaveText1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: FutureBuilder<List<EmployeeInformation>>(
                                    future: getEmpInfo(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        (snapshot.hasError)
                                            ? ''
                                            : (!snapshot.hasData)
                                                ? ''
                                                : "${snapshot.data.first.paidLeave}",
                                        style: TextStyles.leaveText,
                                      );
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ViewColor.text_white_color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 80,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ViewColor.text_grey_footer_color,
                        ),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                Utils.statSub6,
                                style: TextStyles.leaveText1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: FutureBuilder<List<EmployeeInformation>>(
                                    future: getEmpInfo(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        (snapshot.hasError)
                                            ? ''
                                            : (!snapshot.hasData)
                                                ? ''
                                                : "${snapshot.data.first.sickLeave}",
                                        style: TextStyles.leaveText,
                                      );
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ViewColor.text_white_color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'apply for leave',
                        style: TextStyles.personalPageText,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          FocusScope.of(context).unfocus();
                          model.navigateTOLeaveListView();
                        },
                        child: Text(
                          'all applications',
                          style: TextStyles.leaveText2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 400,
                      child: LeaveFormView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: DrawerView(),
        );
      },
    );
  }

  Future<List<EmployeeInformation>> getEmpInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    response = await get(
      Utils.get_employee_info_url + '$empId',
      headers: {'Authorization': 'Bearer $authToken'},
    );
      empList = (json.decode(response.body)['Employee Leave Info'] as List)
          .map((e) => EmployeeInformation.fromJson(e))
          .toList();
    preferences.setString("slug", empList.first.slug);
    return (json.decode(response.body)['Employee Leave Info'] as List)
        .map((e) => EmployeeInformation.fromJson(e))
        .toList();
  }
}
