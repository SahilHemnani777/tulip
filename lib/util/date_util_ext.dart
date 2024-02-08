import 'package:tulip_app/util/date_util.dart';

extension DurationExtension on num {
  get sec => Duration(seconds: toInt());
  get ms => Duration(milliseconds: toInt());
  get minute => Duration(minutes: toInt());
}

extension DateUtilExtension on DateTime {
  // getTimeAgo() {
  //   return timeago.format(this);
  // }

  getDateMonthFormatTime() {
    return DateUtil.getDateMonthFormatTime(this);
  }

  getWeekDayFromDate() {
    return DateUtil.getWeekDayFromDate(this);
  }

  getDisplayFormatDateTime() {
    return DateUtil.getDisplayFormatDateTime(this);
  }

  getDisplayFormatDateTimeDashed() {
    return DateUtil.getDisplayFormatDateTimeDashed(this);
  }

  getDisplayFormatTime() {
    return DateUtil.getDisplayFormatTime(this);
  }

  getDisplayFormatDate() {
    return DateUtil.getDisplayFormatDate(this);
  }

  parseServerFormatDateTime() {
    return DateUtil.getServerFormatDateString(this);
  }
}
