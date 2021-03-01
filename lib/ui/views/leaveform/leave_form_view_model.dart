import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/app/router.gr.dart';
import 'package:unplan/service/attendance_service.dart';

class LeaveFormViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AttendanceService _attendanceService = locator<AttendanceService>();

  postLeave(String type, String fromDate, String toDate, String reasonOfLeave, int totalDays, int paidLeave,
      int sickLeave, int unpaidLeave, int remainPaid, int remainSick) async {
    await _attendanceService.postLeave(
        type, fromDate, toDate, reasonOfLeave, totalDays, paidLeave, sickLeave, unpaidLeave);
    await _attendanceService.updateLeavesCount(remainPaid, remainSick);
    notifyListeners();
  }

  Future navigateTOHomeView() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
  }

  Future navigateTOLeaveListView() async {
    await _navigationService.navigateTo(Routes.leaveLogView);
  }
}
