import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/model/employee_information.dart';
import 'package:unplan/model/leave_list_log.dart';
import 'package:unplan/model/present_by_month.dart';
import 'package:unplan/ui/views/homestats/home_stats_view_model.dart';
import 'package:unplan/utils/date_time_format.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';

class HomeStatsView extends StatefulWidget {
  @override
  _HomeStatsViewState createState() => _HomeStatsViewState();
}

class _HomeStatsViewState extends State<HomeStatsView> {
  List<EmployeeInformation> empList = [];
  List<PresentByMonth> presentList = [];
  List<LeaveListLog> monthlyLeaveList = [];

  @override
  void initState() {
    super.initState();
    getEmpInfo();
    getPresentInfo();
    getMonthlyLeaveInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeStatsViewModel>.reactive(
      viewModelBuilder: () => HomeStatsViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 35.0, right: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.statTitle0,
                  style: TextStyles.homeBottomText,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.statSub1,
                          style: TextStyles.bottomTextStyle2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (model.hasError)
                            ? Text('')
                            : (presentList.length == 0)
                                ? Text(
                                    '0',
                                    style: TextStyles.homeText2,
                                  )
                                : (presentList.length != 0)
                                    ? Text(
                                        "${DateTimeFormat.sumOfPresentOfMonth(presentList)}",
                                        style: TextStyles.homeText2,
                                      )
                                    : Text('0'),
                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       Utils.statSub2,
                    //       style: TextStyles.bottomTextStyle2,
                    //     ),
                    //     SizedBox(
                    //       height: 10,
                    //     ),
                    //     Text(
                    //       '13',
                    //       style: TextStyles.homeText2,
                    //     ),
                    //   ],
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.statSub3,
                          style: TextStyles.bottomTextStyle2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (model.hasError)
                            ? Text('')
                            : (monthlyLeaveList.length == 0)
                                ? Text(
                                    '0',
                                    style: TextStyles.homeText2,
                                  )
                                : Text(
                                    "${DateTimeFormat.sumOfLeavesOfMonth(monthlyLeaveList)}",
                                    style: TextStyles.homeText2,
                                  ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  Utils.statTitle1,
                  style: TextStyles.homeBottomText,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.statSub4,
                            style: TextStyles.bottomTextStyle2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (model.hasError)
                              ? Text('')
                              : (empList.length == 0)
                                  ? Text(
                                      '0',
                                      style: TextStyles.homeText2,
                                    )
                                  : Text(
                                      "${empList.first.paidLeave}",
                                      style: TextStyles.homeText2,
                                    ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 12.0),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         Utils.statSub5,
                      //         style: TextStyles.bottomTextStyle2,
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Text(
                      //         '4',
                      //         style: TextStyles.homeText2,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.statSub6,
                            style: TextStyles.bottomTextStyle2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (model.hasError)
                              ? Text('')
                              : (empList.length == 0)
                                  ? Text(
                                      '0',
                                      style: TextStyles.homeText2,
                                    )
                                  : Text(
                                      "${empList.first.sickLeave}",
                                      style: TextStyles.homeText2,
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    setState(() {
      empList = (json.decode(response.body)['Employee Leave Info'] as List)
          .map((e) => EmployeeInformation.fromJson(e))
          .toList();
    });

    preferences.setString("slug", empList.first.slug);

    return (json.decode(response.body)['Employee Leave Info'] as List)
        .map((e) => EmployeeInformation.fromJson(e))
        .toList();
  }

  Future<List<PresentByMonth>> getPresentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    var queryParameters = {
      'month': DateTime.now().month.toString(),
    };

    var uri = Uri.https('dev.stimulusco.com', '/api/attendenceByMonth/$empId', queryParameters);
    response = await get(
      uri,
      headers: {'Authorization': 'Bearer $authToken'},
    );
    setState(() {
      presentList = (json.decode(response.body)['Employee attendence info by month'] as List)
          .map((e) => PresentByMonth.fromJson(e))
          .toList();
    });
    return (json.decode(response.body)['Employee attendence info by month'] as List)
        .map((e) => PresentByMonth.fromJson(e))
        .toList();
  }

  Future<List<LeaveListLog>> getMonthlyLeaveInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    var queryParameters = {
      'month': DateTime.now().month.toString(),
    };
    var uri = Uri.https('dev.stimulusco.com', '/api/leaveByMonth/$empId', queryParameters);

    response = await get(
      uri,
      headers: {'Authorization': 'Bearer $authToken'},
    );
    setState(() {
      monthlyLeaveList = (json.decode(response.body)['Employee Leave info by month'] as List)
          .map((e) => LeaveListLog.fromJson(e))
          .toList();
    });

    return (json.decode(response.body)['Employee Leave info by month'] as List)
        .map((e) => LeaveListLog.fromJson(e))
        .toList();
  }
}
