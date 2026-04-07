// lib/domain/models/palace.dart
import 'star.dart';

class Palace {
  final int index; // 0-11 的物理位置
  final String name; // 宫位名（命宫、兄弟等）
  final String earthlyBranch; // 地支（子、丑等）
  final List<Star> majorStars; // 十四正星
  final bool isBodyPalace; // 👈 新增此字段以驱动 UI 中的身宫标签
  final List<Star> minorStars; // 辅星与已校对的杂曜
  // =========================================
  // 2. 扩展静态数据 (Extended Static)
  // 严格限制：只存放长生十二神、博士、太岁、将前，以及本命杂曜
  // =========================================
  final List<Star> extendedStars;
  // 🆕 新增：四大神煞系列独立存储
  final String lifeTwelve; // 长生十二神 (每个宫位仅一个)
  final String doctorTwelve; // 博士十二神
  final String taiSuiTwelve; // 太岁十二神
  final String generalTwelve; // 将前诸星

  // =========================================
  // 3. 动态运势数据 (Dynamic Context)
  // 严格限制：大限区间、流年/流月/斗君标记、流曜
  // =========================================
  final List<String> dynamicMarkers; // 存放 ['流年', '斗君'] 等标签
  final List<Star> dynamicStars; // 存放 流羊、流陀、流年四化 等
  final String daXianRange; // 存放 "14-23" 这种大限岁数

  Palace({
    required this.index,
    required this.name,
    required this.earthlyBranch,
    this.isBodyPalace = false, // 👈 默认值为 false，防止现有代码大面积报错
    this.majorStars = const [],
    this.minorStars = const [],
    this.extendedStars = const [],
    this.dynamicMarkers = const [],
    this.dynamicStars = const [],
    this.daXianRange = '',
    required this.lifeTwelve,
    required this.doctorTwelve,
    required this.taiSuiTwelve,
    required this.generalTwelve,
  });
}
