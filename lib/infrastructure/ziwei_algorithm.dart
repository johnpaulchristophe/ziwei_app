// lib/infrastructure/ziwei_algorithm.dart
import 'package:flutter/foundation.dart';
import '../domain/models/models.dart';
import '../domain/ziwei_engine.dart';
import '../domain/logic/time_utils.dart';
import '../domain/logic/palace_calculators.dart';
import '../domain/logic/star_calculators.dart';
import '../domain/constants.dart';
import '../domain/logic/ziwei_mapper.dart';

class ZiweiAlgorithm implements ZiweiEngine {
  @override
  ChartResult generateChart(BirthInput input) {
    // 1. 公历转农历
    final lunarDate = TimeUtils.convertToLunar(input);

    // 🌟🌟🌟 核心手术点：紫微斗数特有闰月处理规则 🌟🌟🌟
    // 规则：闰月十五（含）之前作当月算，十六（含）之后作下个月算
    int astrologyMonth = lunarDate.month;
    if (lunarDate.isLeap && lunarDate.day >= 16) {
      astrologyMonth = lunarDate.month == 12 ? 1 : lunarDate.month + 1;
    }

    debugPrint('--- 历法转换 ---');
    debugPrint('输入公历: ${input.year}-${input.month}-${input.day}');
    debugPrint(
      '对应农历: ${lunarDate.year}年${lunarDate.isLeap ? "闰" : ""}${lunarDate.month}月${lunarDate.day}日',
    );
    if (lunarDate.isLeap) {
      debugPrint('触发闰月规则: 实际排盘使用 $astrologyMonth 月');
    }

    // 2. 生年干支
    final yearGZ = PalaceCalculators.getYearGanZhi(lunarDate.year);
    debugPrint(
      '生年干支: ${ZiweiConstants.GAN[yearGZ.stem]}${ZiweiConstants.ZHIS[yearGZ.zhi]}',
    );

    // 3. 时间归一化
    final normalized = TimeUtils.normalizeTime(input.hour, input.minute);

    // 4. 命宫 & 身宫 (⚠️ 这里全部改用 astrologyMonth)
    final fateIdx = PalaceCalculators.getFateIndex(
      astrologyMonth,
      normalized.timeIndex,
    );
    final bodyIdx = PalaceCalculators.getBodyIndex(
      astrologyMonth,
      normalized.timeIndex,
    );

    // 5. 五行局
    final bureau = PalaceCalculators.getBureau(fateIdx, yearGZ.stem);
    debugPrint('判定五行局: $bureau');

    // 6. 性别标签
    bool isYangYear = yearGZ.stem % 2 == 0;
    bool isMale = input.gender == Gender.male;
    String genderTag = "${isYangYear ? '阳' : '阴'}${isMale ? '男' : '女'}";

    // 7. 计算所有星曜 (⚠️ 这里全部改用 astrologyMonth)
    final stars = StarCalculators.calculateAllStars(
      lunarMonth: astrologyMonth,
      lunarDay: lunarDate.day,
      hVal: normalized.timeIndex,
      yZhi: yearGZ.zhi,
      yStem: yearGZ.stem,
      fateIndex: fateIdx,
      bodyIndex: bodyIdx,
      bureau: bureau,
    );

    final miscStars = StarCalculators.calculateMiscellaneousStars(
      lunarMonth: astrologyMonth,
      lunarDay: lunarDate.day,
      hVal: normalized.timeIndex,
      yStem: yearGZ.stem,
      yZhi: yearGZ.zhi,
      fateIdx: fateIdx,
      bodyIdx: bodyIdx,
      zuofuIdx: stars['左辅']!,
      youbiIdx: stars['右弼']!,
      wenchangIdx: stars['文昌']!,
      wenquIdx: stars['文曲']!,
      isYangP: (isYangYear && isMale) || (!isYangYear && !isMale),
    );

    final allStarPositions = {...stars, ...miscStars};

    // 8. 四化 Map
    final sihuaStars = ZiweiConstants.SIHUA_TABLE[yearGZ.stem]!;
    final sihuaNames = ["禄", "权", "科", "忌"];
    final Map<String, String> sihuaMap = {};
    for (int j = 0; j < 4; j++) {
      sihuaMap[sihuaStars[j]] = sihuaNames[j];
    }

    // 9. 调用 Mapper (⚠️ 传给前端展示的月份也改用排盘计算月)
    return ZiweiMapper.mapToChartResult(
      starPositions: allStarPositions,
      sihuaMap: sihuaMap,
      fateIdx: fateIdx,
      bodyIdx: bodyIdx,
      yStem: yearGZ.stem,
      yZhi: yearGZ.zhi,
      bureau: bureau,
      destinyBranch: ZiweiConstants.ZHIS[fateIdx],
      genderTag: genderTag,
      lunarMonth: astrologyMonth, // 👈 统一使用推算后的月份
      lunarDay: lunarDate.day,
      timeIndex: normalized.timeIndex,
    );
  }
}
