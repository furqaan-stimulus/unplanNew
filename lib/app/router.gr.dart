// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/drawer/drawer_view.dart';
import '../ui/views/employee/employee_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/homelog/home_log_view.dart';
import '../ui/views/homestats/home_stats_view.dart';
import '../ui/views/leaveapplication/leave_application_view.dart';
import '../ui/views/leavelog/leave_log_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/personalInfo/personal_info_view.dart';
import '../ui/views/splash/splash_view.dart';

class Routes {
  static const String splashView = '/';
  static const String homeView = '/home-view';
  static const String homeLogView = '/home-log-view';
  static const String homeStatsView = '/home-stats-view';
  static const String loginView = '/login-view';
  static const String employeeView = '/employee-view';
  static const String leaveApplicationView = '/leave-application-view';
  static const String leaveLogView = '/leave-log-view';
  static const String drawerView = '/drawer-view';
  static const String personalInfoView = '/personal-info-view';
  static const all = <String>{
    splashView,
    homeView,
    homeLogView,
    homeStatsView,
    loginView,
    employeeView,
    leaveApplicationView,
    leaveLogView,
    drawerView,
    personalInfoView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.homeLogView, page: HomeLogView),
    RouteDef(Routes.homeStatsView, page: HomeStatsView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.employeeView, page: EmployeeView),
    RouteDef(Routes.leaveApplicationView, page: LeaveApplicationView),
    RouteDef(Routes.leaveLogView, page: LeaveLogView),
    RouteDef(Routes.drawerView, page: DrawerView),
    RouteDef(Routes.personalInfoView, page: PersonalInfoView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    HomeLogView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeLogView(),
        settings: data,
      );
    },
    HomeStatsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeStatsView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    EmployeeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EmployeeView(),
        settings: data,
      );
    },
    LeaveApplicationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LeaveApplicationView(),
        settings: data,
      );
    },
    LeaveLogView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LeaveLogView(),
        settings: data,
      );
    },
    DrawerView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => DrawerView(),
        settings: data,
      );
    },
    PersonalInfoView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PersonalInfoView(),
        settings: data,
      );
    },
  };
}
