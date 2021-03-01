import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/employee/employee_view_model.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';

class EmployeeView extends StatefulWidget {
  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployeeViewModel>.nonReactive(
      viewModelBuilder: () => EmployeeViewModel(),
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
                  'employee info',
                  style: TextStyles.personalPageText,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          drawer: DrawerView(),
        );
      },
    );
  }
}
