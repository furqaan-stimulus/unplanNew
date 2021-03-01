import 'package:stacked/stacked.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/service/attendance_service.dart';
import 'package:unplan/utils/utils.dart';

class HomeLogViewModel extends BaseViewModel {
  // double _officeLat = double.parse((23.041747).toStringAsFixed(2));
  // double _officeLong = double.parse((72.5518427).toStringAsFixed(2));
  //
  // double _homeLat = double.parse((23.029326).toStringAsFixed(2));
  // double _homeLong = double.parse((72.5963621).toStringAsFixed(2));

  final AttendanceService _attendanceService = locator<AttendanceService>();

  markClockIn(context, double latitude, double longitude, String address) async {
    await _attendanceService.markLog(Utils.CLOCKIN, address, latitude, longitude, 0, 0);
  }

  markClockOut(totalHour, context, double latitude, double longitude, String address) async {
    int present = 0;
    var sat = DateTime.saturday;
    var currentDay = DateTime.now().weekday;

    if (currentDay == sat) {
      if (totalHour > 5.00) {
        await _attendanceService.markLog(Utils.CLOCKOUT, address, latitude, longitude, present + 1, totalHour);
      } else {
        await _attendanceService.markLog(Utils.CLOCKOUT, address, latitude, longitude, present, 0);
      }
    } else {
      if (totalHour > 6.00) {
        await _attendanceService.markLog(Utils.CLOCKOUT, address, latitude, longitude, present + 1, totalHour);
      } else {
        await _attendanceService.markLog(Utils.CLOCKOUT, address, latitude, longitude, present, 0);
      }
    }
  }

  markClockTimeOut(context, double latitude, double longitude, String address) async {
    await _attendanceService.markLog(Utils.TIMEOUT, address, latitude, longitude, 0, 0);
  }
}
