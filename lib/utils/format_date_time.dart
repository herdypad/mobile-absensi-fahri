import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class FormatDateTime {
  static String formatID({
    required String value,
    DateFormat? format,
  }) {
    initializeDateFormatting();
    format ??= DateFormat('dd MMMM yyyy', "id_ID");
    try {
      var p = DateTime.parse(value.toString());
      return format.format(p);
    } catch (e) {
      return 'Invalid date';
    }
  }

  static String shortDayName(DateTime value) {
    switch (value.weekday) {
      case 1:
        return 'mondayShort'.tr;
      case 2:
        return 'tuesdayShort'.tr;
      case 3:
        return 'wednesdayShort'.tr;
      case 4:
        return 'thursdayShort'.tr;
      case 5:
        return 'fridayShort'.tr;
      case 6:
        return 'saturdayShort'.tr;
      default:
        return 'sundayShort'.tr;
    }
  }

  static String shortMonthName(DateTime value) {
    switch (value.month) {
      case 1:
        return 'januaryShort'.tr;
      case 2:
        return 'februaryShort'.tr;
      case 3:
        return 'marchShort'.tr;
      case 4:
        return 'AprilShort'.tr;
      case 5:
        return 'meyShort'.tr;
      case 6:
        return 'juneShort'.tr;
      case 7:
        return 'julyShort'.tr;
      case 8:
        return 'augustShort'.tr;
      case 9:
        return 'septemberShort'.tr;
      case 10:
        return 'octoberShort'.tr;
      case 11:
        return 'novemberShort'.tr;
      default:
        return 'decemberShort'.tr;
    }
  }
}
