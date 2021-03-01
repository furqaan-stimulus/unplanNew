import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unplan/service/attendance_service.dart';
import 'package:unplan/service/auth_service.dart';
import 'package:unplan/service/shared_pref_service.dart';

@module
abstract class ThirdPartyServiceModule {
  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  DialogService get dialogService;

  @lazySingleton
  SnackbarService get snackBarService;

  @lazySingleton
  AuthService get authService;

  @lazySingleton
  SharedPrefService get sharedPrefService;

  @lazySingleton
  AttendanceService get attendanceService;
}
