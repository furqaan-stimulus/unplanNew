import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/model/personal_information.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/personalInfo/personal_info_view_model.dart';
import 'package:unplan/utils/date_time_format.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/widgets/custom_check_box.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalInfoView extends StatefulWidget {
  @override
  _PersonalInfoViewState createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  List<PersonalInformation> userDataList = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonalInfoViewModel>.nonReactive(
      viewModelBuilder: () => PersonalInfoViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldState,
          body: Padding(
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
                  height: 30,
                ),
                Text(
                  'personal info',
                  style: TextStyles.personalPageText,
                ),
                SizedBox(
                  height: 20,
                ),
                (model.hasError)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (userDataList.length == 0)
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (userDataList.first.fname == null) ? "" : "${userDataList.first.fname}",
                                        style: TextStyles.personalPageText2,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (userDataList.first.role == null) ? "" : "${userDataList.first.role}",
                                        style: TextStyles.personalPageText3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mobile",
                                        style: TextStyles.personalPageText5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (userDataList.first.mobile == null) ? "" : "${userDataList.first.mobile}",
                                        style: TextStyles.personalPageText3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: CustomCheckBox(),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address",
                                          style: TextStyles.personalPageText5,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: (userDataList.first.raSociety == null)
                                                  ? ""
                                                  : "${userDataList.first.raSociety}",
                                              style: TextStyles.personalPageText3,
                                            ),
                                            TextSpan(
                                              text: (userDataList.first.raArea == null)
                                                  ? ""
                                                  : " ${userDataList.first.raArea}",
                                              style: TextStyles.personalPageText3,
                                            ),
                                            TextSpan(
                                              text: (userDataList.first.raCity == null)
                                                  ? ""
                                                  : " ${userDataList.first.raCity}",
                                              style: TextStyles.personalPageText3,
                                            ),
                                            TextSpan(
                                              text: (userDataList.first.raState == null)
                                                  ? ""
                                                  : " ${userDataList.first.raState}",
                                              style: TextStyles.personalPageText3,
                                            ),
                                            TextSpan(
                                              text: (userDataList.first.raPincode == null)
                                                  ? ""
                                                  : " ${userDataList.first.raPincode}",
                                              style: TextStyles.personalPageText3,
                                            ),
                                          ]),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Working with Stimulus since",
                                        style: TextStyles.personalPageText5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (userDataList.first.joiningDate == null)
                                            ? "not specified"
                                            : DateTimeFormat.birthDate("${userDataList.first.joiningDate}"),
                                        style: TextStyles.personalPageText3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Birthday",
                                        style: TextStyles.personalPageText5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (userDataList.first.dob == null)
                                            ? ""
                                            : DateTimeFormat.birthDate("${userDataList.first.dob}"),
                                        style: TextStyles.personalPageText3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCheckBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Emergency Contact",
                                        style: TextStyles.personalPageText5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: (userDataList.first.emergencyContact == null)
                                              ? ""
                                              : "${userDataList.first.emergencyContact} ",
                                          style: TextStyles.personalPageText3,
                                        ),
                                        TextSpan(
                                          text: (userDataList.first.relationshipEmergency == null)
                                              ? "[not specified]"
                                              : "[${userDataList.first.relationshipEmergency}]",
                                          style: TextStyles.personalPageText3,
                                        ),
                                      ])),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                (model.hasError)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (userDataList.length != 0)
                        ? GestureDetector(
                            onTap: () {
                              launch(_uri.toString());
                            },
                            child: Text(
                              'Something’s not right? Contact HR',
                              style: TextStyles.personalPageText4,
                            ),
                          )
                        : Center(
                            child: Text(''),
                          ),
              ],
            ),
          ),
          drawer: DrawerView(),
        );
      },
    );
  }

  Future<List<PersonalInformation>> getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authToken = preferences.getString('token');
    int empId = preferences.getInt('id');
    Response response;
    response = await get(
      Utils.personal_info_url + '$empId',
      headers: {'Authorization': 'Bearer $authToken'},
    );
    setState(() {
      userDataList =
          (json.decode(response.body)['Personal Info'] as List).map((e) => PersonalInformation.fromJson(e)).toList();
    });
    return (json.decode(response.body)['Personal Info'] as List).map((e) => PersonalInformation.fromJson(e)).toList();
  }

  final Uri _uri = Uri(
    scheme: 'mailto',
    path: 'office@stimulusconsultancy.com',
    queryParameters: {
      'subject': '',
      'body': '',
    },
  );
}
