import 'package:auto_route/auto_route_annotations.dart';
import 'package:unplan/ui/views/drawer/drawer_view.dart';
import 'package:unplan/ui/views/employee/employee_view.dart';
import 'package:unplan/ui/views/home/home_view.dart';
import 'package:unplan/ui/views/homelog/home_log_view.dart';
import 'package:unplan/ui/views/homestats/home_stats_view.dart';
import 'package:unplan/ui/views/leaveapplication/leave_application_view.dart';
import 'package:unplan/ui/views/leavelog/leave_log_view.dart';
import 'package:unplan/ui/views/login/login_view.dart';
import 'package:unplan/ui/views/personalInfo/personal_info_view.dart';
import 'package:unplan/ui/views/splash/splash_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: SplashView,
      initial: true,
    ),
    MaterialRoute(
      page: HomeView,
    ),
    MaterialRoute(
      page: HomeLogView,
    ),
    MaterialRoute(
      page: HomeStatsView,
    ),
    MaterialRoute(
      page: LoginView,
    ),
    MaterialRoute(
      page: EmployeeView,
    ),
    MaterialRoute(
      page: LeaveApplicationView,
    ),
    MaterialRoute(
      page: LeaveLogView,
    ),
    MaterialRoute(
      page: DrawerView,
    ),
    MaterialRoute(
      page: PersonalInfoView,
    ),
  ],
)
class $Router {}
