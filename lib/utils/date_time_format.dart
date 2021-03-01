import 'package:intl/intl.dart';
import 'package:unplan/model/leave_list_log.dart';
import 'package:unplan/model/present_by_month.dart';
import 'package:unplan/model/today_log.dart';

class DateTimeFormat {
  static String formatDateTime(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('HH:mm a, d MMM');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static String homeDate() {
    var now = DateTime.now();
    var format = DateFormat('EEEE, MMM d yyyy').format(now);
    return format;
  }

  static String birthDate(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('dd MMMM yyyy');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static String leaveDate(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('dd/MM/yy');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static String hoursToday(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('HH:mm');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static String pickerDateFormat(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('dd/MM/yyyy');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static String leaveDate1(String dateString) {
    var inputDate = DateTime.parse(dateString);
    var formatDate = DateFormat('dd/MM');
    var newFormat = formatDate.format(inputDate);
    return newFormat.toString();
  }

  static Duration difference() {
    DateTime notificationDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 30, 00);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    return difference;
  }

  static double calculateHoursForSingleDay(List<TodayLog> logs, {String unit = 'hours'}) {
    List<Duration> pairs = createPairsFromList(logs);
    double timeInSeconds = pairs.fold(
      0,
      (previousValue, element) {
        return previousValue + element.inSeconds;
      },
    );
    switch (unit) {
      case 'hours':
        {
          return double.parse((timeInSeconds / (60 * 60)).toStringAsFixed(2));
        }

      case 'minutes':
        {
          return double.parse((timeInSeconds / (60)).toStringAsFixed(2));
        }

      case 'seconds':
        {
          return double.parse((timeInSeconds / (1)).toStringAsFixed(2));
        }
    }
  }

  static List<Duration> createPairsFromList(List<TodayLog> logs) {
    return logs.map((value) {
      int nextElementIndex = logs.indexOf(value) + 1;
      if (logs.length != nextElementIndex) {
        return value.getDateWithMinutes().difference(logs[nextElementIndex].getDateWithMinutes());
      } else {
        return Duration.zero;
      }
    }).toList();
  }

  static int sumOfLeavesOfMonth(List<LeaveListLog> logs) {
    int sum = logs.fold(0, (totalDays, leaveList) => totalDays + leaveList.getTotalLeaveDays());
    return sum;
  }

  static int sumOfPresentOfMonth(List<PresentByMonth> logs) {
    int sum = logs.fold(0, (totalDays, presentDays) => totalDays + presentDays.present);
    return sum;
  }

  static double averageOfMonth(List<PresentByMonth> logs) {
    var currentMonth = DateTime.now().month;

    if (currentMonth == DateTime.january ||
        currentMonth == DateTime.march ||
        currentMonth == DateTime.may ||
        currentMonth == DateTime.july ||
        currentMonth == DateTime.august ||
        currentMonth == DateTime.october ||
        currentMonth == DateTime.december) {
    } else if (currentMonth == DateTime.april || currentMonth == DateTime.june || currentMonth == DateTime.september) {
    } else if (currentMonth == DateTime.february) {}

    return 0;
  }
}
