import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/home/home_view_model.dart';
import 'package:unplan/ui/views/homelog/home_log_view.dart';
import 'package:unplan/ui/views/homestats/home_stats_view.dart';
import 'package:unplan/utils/date_time_format.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:timezone/data/latest.dart' as tzd;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
    return ViewModelBuilder<HomeViewModel>.nonReactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        tzd.initializeTimeZones();
        model.initializeNotification();
      },
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldState,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: 15.0,
                      ),
                      FutureBuilder(
                        future: model.getName(),
                        builder: (context, snapshot) => RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: Utils.HI, style: TextStyles.homeTitle),
                              snapshot.hasData
                                  ? TextSpan(text: '${snapshot.data}', style: TextStyles.homeTitle)
                                  : TextSpan(text: ''),
                              TextSpan(text: Utils.COMMA, style: TextStyles.homeTitle),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        DateTimeFormat.homeDate(),
                        style: TextStyles.homeSubTitle,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: double.infinity,
                child: HomeLogView(),
              ),
              Container(
                height: 300,
                child: HomeStatsView(),
              ),
            ],
          ),
          drawer: DrawerView(),
        );
      },
    );
  }
}
