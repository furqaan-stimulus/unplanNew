import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/model/employee_information.dart';
import 'package:unplan/model/leave_list_log.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/leavelog/leave_log_view_model.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';
import 'package:unplan/widgets/leave_list_item.dart';

class LeaveLogView extends StatefulWidget {
  @override
  _LeaveLogViewState createState() => _LeaveLogViewState();
}

class _LeaveLogViewState extends State<LeaveLogView> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  List<EmployeeInformation> empList = [];
  List<LeaveListLog> leaveList = [];
  List<LeaveListLog> yearlyLeaveList = [];
  bool isFiltered = false;

  @override
  void initState() {
    super.initState();
    getEmpInfo();
    getLeaveListInfo();
    getYearlyLeaveListInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaveLogViewModel>.nonReactive(
      viewModelBuilder: () => LeaveLogViewModel(),
      builder: (context, model, child) {
        return Scaffold(
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
                        'leave applications',
                        style: TextStyles.personalPageText,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              isFiltered = !isFiltered;
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/filter.svg",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'this year',
                              style: TextStyles.leaveText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: ViewColor.text_grey_color,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Applied",
                          style: TextStyles.leaveText3,
                        ),
                        Text(
                          "Duration",
                          style: TextStyles.leaveText3,
                        ),
                        Text(
                          "Type",
                          style: TextStyles.leaveText3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Status",
                            style: TextStyles.leaveText3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: ViewColor.text_grey_color,
                    thickness: 2,
                  ),
                  (isFiltered == false)
                      ? Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: leaveList.length,
                              itemBuilder: (context, index) {
                                if (leaveList.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (leaveList.length == 0) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return LeaveListItem(
                                    log: leaveList[index],
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: yearlyLeaveList.length,
                              itemBuilder: (context, index) {
                                if (yearlyLeaveList.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (yearlyLeaveList.length == 0) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return LeaveListItem(
                                    log: yearlyLeaveList[index],
                                  );
                                }
                              },
                            ),
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

  Future<List<LeaveListLog>> getLeaveListInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    response = await get(
      Utils.get_leave_url + '$empId',
      headers: {'Authorization': 'Bearer $authToken'},
    );
    setState(() {
      leaveList =
          (json.decode(response.body)['Employee Leave Info'] as List).map((e) => LeaveListLog.fromJson(e)).toList();
    });
    preferences.setString("slug", empList.first.slug);
    return (json.decode(response.body)['Employee Leave Info'] as List).map((e) => LeaveListLog.fromJson(e)).toList();
  }

  Future<List<LeaveListLog>> getYearlyLeaveListInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    var queryParameters = {
      'year': DateTime.now().year.toString(),
    };
    var uri = Uri.https('dev.stimulusco.com', '/api/leaveByYear/$empId', queryParameters);
    response = await get(
      uri,
      headers: {'Authorization': 'Bearer $authToken'},
    );
    setState(() {
      yearlyLeaveList = (json.decode(response.body)['Employee Leave info by year'] as List)
          .map((e) => LeaveListLog.fromJson(e))
          .toList();
    });

    return (json.decode(response.body)['Employee Leave info by year'] as List)
        .map((e) => LeaveListLog.fromJson(e))
        .toList();
  }
}
