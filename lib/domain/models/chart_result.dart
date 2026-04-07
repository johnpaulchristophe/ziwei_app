// lib/domain/models/chart_result.dart
import 'palace.dart';

class ChartResult {
  final String fiveElements; // 五行局
  final String destinyBranch; // 命宫地支（如 "子"）
  final String genderTag; // 👈 新增：例如 "阳男"
  final List<Palace> palaces; // 12宫数据
  final int lunarMonth; // 农历出生月份 (1-12)
  final int timeIndex; // 出生时辰索引 (子时=0, 丑时=1...亥时=11)
  // 🆕 追加这两个字符串字段
  // 🆕 新增：彻底打通中宫需要的时间数据
  final String yearGanZhi;
  final int lunarDay;
  final String lifeLord;
  final String bodyLord;

  ChartResult({
    required this.fiveElements,
    required this.destinyBranch,
    required this.genderTag, // 👈 记得更新构造函数
    required this.palaces,
    required this.lunarMonth,
    required this.timeIndex,
    required this.lifeLord, // 👈 加这里
    required this.bodyLord, // 👈 加这里
    required this.yearGanZhi, // 👈 补上
    required this.lunarDay, // 👈 补上
  });
}
