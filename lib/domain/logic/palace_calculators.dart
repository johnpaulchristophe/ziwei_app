import '../constants.dart';

class PalaceCalculators {
  // 紫微斗数核心公式：寅宫起正月，顺数月，逆数时
  static int getFateIndex(int lunarMonth, int timeIndex) {
    int startPos = 2; // 寅宫的索引是 2
    return (startPos + (lunarMonth - 1) - timeIndex + 12) % 12;
  }

  static ({int stem, int zhi}) getYearGanZhi(int year) {
    return (stem: (year - 4) % 10, zhi: (year - 4) % 12);
  }

  /// 2. 算起寅宫的天干（寻找规律：甲己起丙寅...）
  static int getYinStem(int yearStem) {
    List<int> tigerStems = [2, 4, 6, 8, 0]; // 丙, 戊, 庚, 壬, 甲
    return tigerStems[yearStem % 5];
  }

  /// 3. 根据命宫位置算出命宫的纳音五行局
  static String getBureau(int fateIdx, int yearStem) {
    int yinStem = getYinStem(yearStem);
    // 命宫的天干 = (起寅宫天干 + 偏移量) % 10
    // 注意：命宫索引 fateIdx 对应的是地支索引，寅是2
    int offset = (fateIdx - 2 + 12) % 12;
    int fateStemIdx = (yinStem + offset) % 10;

    String stemStr = ZiweiConstants.GAN[fateStemIdx];
    String zhiStr = ZiweiConstants.ZHIS[fateIdx];

    return ZiweiConstants.NAYIN_BUREAU[stemStr + zhiStr] ?? "水二局";
  }

  static int getBodyIndex(int lunarMonth, int hourIdx) {
    // 身宫公式：寅(2)起正月，顺数月，再顺数时
    // (2 + (月-1) + 时) % 12
    return (2 + (lunarMonth - 1) + hourIdx) % 12;
  }
}
