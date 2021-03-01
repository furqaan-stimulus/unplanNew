// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i5;

import '../service/attendance_service.dart' as _i3;
import '../service/auth_service.dart' as _i4;
import '../service/shared_pref_service.dart' as _i6;
import '../service/third_party_service_module.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServiceModule = _$ThirdPartyServiceModule();
  gh.lazySingleton<_i3.AttendanceService>(
      () => thirdPartyServiceModule.attendanceService);
  gh.lazySingleton<_i4.AuthService>(() => thirdPartyServiceModule.authService);
  gh.lazySingleton<_i5.DialogService>(
      () => thirdPartyServiceModule.dialogService);
  gh.lazySingleton<_i5.NavigationService>(
      () => thirdPartyServiceModule.navigationService);
  gh.lazySingleton<_i6.SharedPrefService>(
      () => thirdPartyServiceModule.sharedPrefService);
  gh.lazySingleton<_i5.SnackbarService>(
      () => thirdPartyServiceModule.snackBarService);
  return get;
}

class _$ThirdPartyServiceModule extends _i7.ThirdPartyServiceModule {
  @override
  _i3.AttendanceService get attendanceService => _i3.AttendanceService();
  @override
  _i4.AuthService get authService => _i4.AuthService();
  @override
  _i5.DialogService get dialogService => _i5.DialogService();
  @override
  _i5.NavigationService get navigationService => _i5.NavigationService();
  @override
  _i6.SharedPrefService get sharedPrefService => _i6.SharedPrefService();
  @override
  _i5.SnackbarService get snackBarService => _i5.SnackbarService();
}
