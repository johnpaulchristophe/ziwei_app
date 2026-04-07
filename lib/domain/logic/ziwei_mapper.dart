// lib/domain/logic/ziwei_mapper.dart

import '../models/models.dart';
import '../constants.dart';
import './star_calculators.dart';
import 'package:lunar/lunar.dart';

class ZiweiMapper {
  static ChartResult mapToChartResult({
    required Map<String, int> starPositions,
    required Map<String, String> sihuaMap,
    required int fateIdx,
    required int bodyIdx,
    required int yStem, // 年天干索引
    required int yZhi,
    required String bureau,
    required String destinyBranch,
    required String genderTag,
    // 🆕 新增这两个入参，让 Mapper 能接收到外部传来的真实出生数据
    required int lunarMonth,
    required int lunarDay, // 👈 补上入参
    required int timeIndex,
    DateTime? targetDate, // 🆕 新增：用于看流年流月的目标时间，默认不传就是当前时间
  }) {
    final majorNames = [
      "紫微",
      "天机",
      "太阳",
      "武曲",
      "天同",
      "廉贞",
      "天府",
      "太阴",
      "贪狼",
      "巨门",
      "天相",
      "天梁",
      "七杀",
      "破军",
    ];
    final minorNames = [
      "左辅",
      "右弼",
      "文昌",
      "文曲",
      "天魁",
      "天钺",
      "禄存",
      "天马",
      "擎羊",
      "陀罗",
      "地劫",
      "地空",
      "火星", // 👈 补上
      "铃星", // 👈 补上
    ];
    final miscNames = [
      "三台",
      "八座",
      "恩光",
      "天贵",
      "台辅",
      "封诰",
      "天才",
      "天寿",
      "龙池",
      "凤阁",
      "孤辰",
      "寡宿",
      "劫煞",
      "大耗",
      "蜚廉",
      "破碎",
      "华盖",
      "咸池",
      "龙德",
      "月德",
      "天德",
      "年解",
      "天空",
      "红鸾",
      "天喜",
      "天哭",
      "天虚",
      "天官",
      "天福",
      "天厨",
      "截空",
      "副截",
      "旬空",
      "副旬",
      "天刑",
      "天姚",
      "解神",
      "天巫",
      "天月",
      "阴煞",
      "天伤",
      "天使",
    ];

    // 1. 【精准修正】五虎遁基准点
    // 根据年干(yStem)算出正月(寅位)的天干起点
    // 甲己年(0,5)起丙寅(2)，乙庚年(1,6)起戊寅(4)，丙辛(2,7)起庚寅(6)...
    int startGanIdx = (yStem % 5) * 2 + 2;

    final changShengPositions = StarCalculators.calculateChangSheng12(
      bureau: bureau,
      genderTag: genderTag,
    );

    final int luCunPos = starPositions['禄存'] ?? 0;
    final taiSui12 = StarCalculators.calculateTaiSui12(yZhi);
    final doctor12 = StarCalculators.calculateDoctor12(luCunPos, genderTag);
    final general12 = StarCalculators.calculateGeneral12(yZhi);

    final lifeLord = StarCalculators.getLifeLord(fateIdx);
    final bodyLord = StarCalculators.getBodyLord(yZhi);
    final viewDate = targetDate ?? DateTime.now(); // 拿到看盘时间
    final lunarNow = Lunar.fromDate(viewDate);
    final currentLiuNianZhi = lunarNow.getYearZhi();
    final currentLunarMonth = lunarNow.getMonth().abs();

    final liuNianIdx = StarCalculators.getLiuNianPalaceIdx(currentLiuNianZhi);
    final douJunIdx = StarCalculators.getDouJunPalaceIdx(
      liuNianIdx: liuNianIdx,
      birthMonth: lunarMonth,
      birthHourIdx: timeIndex,
    );
    final liuYueIdx = StarCalculators.getLiuYuePalaceIdx(
      liuNianIdx: liuNianIdx,
      birthMonth: lunarMonth,
      birthHourIdx: timeIndex,
      targetMonth: currentLunarMonth,
    );

    List<Palace> palaces = List.generate(12, (i) {
      // 计算宫职名称索引 (0=命宫, 1=兄弟...)
      int nameIdx = (fateIdx - i + 12) % 12;
      String palaceName = ZiweiConstants.PALACE_NAMES[nameIdx];
      bool isBody = (i == bodyIdx); // 是否身宫直接算出
      int currentGanIdx;
      if (i >= 2) {
        currentGanIdx = (startGanIdx + (i - 2)) % 10;
      } else {
        currentGanIdx = (startGanIdx + i) % 10;
      }
      String ganZhi =
          "${ZiweiConstants.GAN[currentGanIdx]}${ZiweiConstants.ZHIS[i]}";
      String lifeTwelveName = "";
      String doctorTwelveName = "";
      String taiSuiTwelveName = "";
      String generalTwelveName = "";

      // 🛑 核心分流篮子！
      List<Star> majorStarsInPalace = [];
      List<Star> minorStarsInPalace = [];
      List<Star> extendedStarsInPalace = []; // 专装神煞
      List<String> dynamicMarkers = []; // 专装流年标签

      // 1. 分拣已有星曜
      starPositions.forEach((name, pos) {
        if (pos == i) {
          final brightness = StarCalculators.getStarBrightness(name, i);
          final star = Star(
            name: name,
            modifier: sihuaMap[name],
            brightness: brightness,
          );

          if (majorNames.contains(name)) {
            majorStarsInPalace.add(star);
          } else if (minorNames.contains(name)) {
            // 只有六吉六煞禄马能进这里
            minorStarsInPalace.add(star);
          } else if (miscNames.contains(name)) {
            // 所有杂曜被发配到扩展层
            extendedStarsInPalace.add(star);
          }
        }
      });

      changShengPositions.forEach((name, pos) {
        if (pos == i) lifeTwelveName = name;
      });
      doctor12.forEach((name, pos) {
        if (pos == i) doctorTwelveName = name;
      });
      taiSui12.forEach((name, pos) {
        if (pos == i) taiSuiTwelveName = name;
      });
      general12.forEach((name, pos) {
        if (pos == i) generalTwelveName = name;
      });

      // 3. 计算本宫位的大限与动态标记
      final daXianText = StarCalculators.getDaXianRange(
        targetIdx: i,
        lifeIdx: fateIdx,
        bureau: bureau,
        genderTag: genderTag,
      );
      if (i == liuNianIdx) dynamicMarkers.add('流年');
      if (i == douJunIdx) dynamicMarkers.add('斗君');
      if (i == liuYueIdx) dynamicMarkers.add('流月');

      // 4. 返回组装好的纯净 Palace 对象
      return Palace(
        index: i,
        name: palaceName,
        isBodyPalace: isBody, // 传给 UI 处理
        earthlyBranch: ganZhi,
        majorStars: majorStarsInPalace,
        minorStars: minorStarsInPalace,
        extendedStars: extendedStarsInPalace, // 神煞归位
        lifeTwelve: lifeTwelveName,
        doctorTwelve: doctorTwelveName,
        taiSuiTwelve: taiSuiTwelveName,
        generalTwelve: generalTwelveName,
        dynamicMarkers: dynamicMarkers, // 流年归位
        daXianRange: daXianText, // 大限归位
      );
    });

    final String yGanZhiStr =
        "${ZiweiConstants.GAN[yStem]}${ZiweiConstants.ZHIS[yZhi]}";

    return ChartResult(
      fiveElements: bureau,
      destinyBranch: destinyBranch,
      genderTag: genderTag,
      palaces: palaces,
      lunarMonth: lunarMonth,
      timeIndex: timeIndex,
      lifeLord: lifeLord,
      bodyLord: bodyLord,
      yearGanZhi: yGanZhiStr, // 👈 传给模型
      lunarDay: lunarDay, // 👈 传给模型
    );
  }
}
