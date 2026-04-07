import 'package:lunar/lunar.dart';
import '../models/models.dart';

class TimeUtils {
  // 这个函数负责把 23:15 变成“第二天”的“子时”
  static ({int timeIndex, bool isNextDay}) normalizeTime(int hour, int minute) {
    int timeIndex = ((hour + 1) % 24 / 2).floor();
    bool isNextDay = hour >= 23; // 23点以后就是第二天了
    return (timeIndex: timeIndex, isNextDay: isNextDay);
  }

  static ({int year, int month, int day, bool isLeap}) convertToLunar(
    BirthInput input,
  ) {
    // 1. 如果用户本来选的就是农历，直接返回
    if (input.dateType == CalendarType.lunar) {
      return (
        year: input.year,
        month: input.month,
        day: input.day,
        isLeap: input.isLeapMonth,
      );
    }

    // 2. 如果是公历，调用 Lunar 库转换
    Solar solar = Solar.fromYmd(input.year, input.month, input.day);
    Lunar lunar = solar.getLunar();

    return (
      year: lunar.getYear(),
      month: lunar.getMonth().abs(), // 农历月份
      day: lunar.getDay(),
      isLeap: lunar.getMonth() < 0, // 库中负数表示闰月
    );
  }
}
