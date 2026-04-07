// lib/domain/logic/star_calculators.dart

class StarCalculators {
  static Map<String, int> calculateAllStars({
    required int lunarMonth,
    required int lunarDay,
    required int hVal,
    required int yZhi,
    required int yStem,
    required int fateIndex,
    required int bodyIndex,
    required String bureau,
  }) {
    Map<String, int> s = {};

    // 1. 定紫微星位置 (核心公式)
    int bValue = _getBureauValue(bureau);
    int zwNum = (lunarDay % bValue == 0)
        ? (lunarDay ~/ bValue)
        : (((bValue - lunarDay % bValue) % 2 == 1)
              ? ((lunarDay + bValue - lunarDay % bValue) ~/ bValue) -
                    (bValue - lunarDay % bValue)
              : ((lunarDay + bValue - lunarDay % bValue) ~/ bValue) +
                    (bValue - lunarDay % bValue));

    s['紫微'] = (2 + (zwNum - 1) + 12) % 12;

    // 2. 十四主星联动 (根据紫微和天府定位置)
    int zw = s['紫微']!;
    s['天机'] = (zw - 1 + 12) % 12;
    s['太阳'] = (zw - 3 + 12) % 12;
    s['武曲'] = (zw - 4 + 12) % 12;
    s['天同'] = (zw - 5 + 12) % 12;
    s['廉贞'] = (zw - 8 + 12) % 12;

    int tf = (16 - zw) % 12; // 天府公式
    s['天府'] = tf;
    s['太阴'] = (tf + 1) % 12;
    s['贪狼'] = (tf + 2) % 12;
    s['巨门'] = (tf + 3) % 12;
    s['天相'] = (tf + 4) % 12;
    s['天梁'] = (tf + 5) % 12;
    s['七杀'] = (tf + 6) % 12;
    s['破军'] = (tf + 10) % 12;

    // 3. 六吉六煞 (常用的辅星)
    s['左辅'] = (4 + (lunarMonth - 1)) % 12;
    s['右弼'] = (10 - (lunarMonth - 1) + 12) % 12;
    s['文曲'] = (4 + hVal) % 12;
    s['文昌'] = (10 - hVal + 12) % 12;
    s['地劫'] = (11 + hVal) % 12;
    s['地空'] = (11 - hVal + 12) % 12;

    // 1. 定义甲、乙、丙、丁、戊、己、庚、辛、壬、癸对应的禄存原始位置
    // 原始位置索引 (基于 HTML 逻辑：0=巳, 1=午...)
    // 甲(寅), 乙(卯), 丙(巳), 丁(午), 戊(巳), 己(午), 庚(申), 辛(酉), 壬(亥), 癸(子)
    final rawLucunPos = [9, 10, 0, 1, 0, 1, 3, 4, 6, 7];

    // 2. 计算物理索引 (加上 5 的偏移量并取模 12)
    // 这样：甲年禄存在 寅(2)，乙年禄存在 卯(3)... 完美对齐子位起算的 4x4 宫格
    s['禄存'] = (rawLucunPos[yStem] + 5) % 12;

    // 3. 擎羊恒在禄存前一宫（顺时针+1）
    s['擎羊'] = (s['禄存']! + 1) % 12;

    // 4. 陀罗恒在禄存后一宫（逆时针-1）
    s['陀罗'] = (s['禄存']! - 1 + 12) % 12;

    // 天魁、天钺
    final rawKui = [8, 7, 6, 6, 8, 9, 8, 10, 0, 1];
    final rawYue = [2, 3, 4, 4, 2, 1, 2, 0, 10, 9];
    s['天魁'] = (rawKui[yStem] + 5) % 12;
    s['天钺'] = (rawYue[yStem] + 5) % 12;
    // 补入火星、铃星计算（已完美转换为子=0坐标系）
    // ==========================================

    // 火星：依生年地支查表定起点，顺数至生时
    s['火星'] = ([2, 3, 1, 9, 2, 3, 1, 9, 2, 3, 1, 9][yZhi] + hVal) % 12;

    // 铃星：依生年地支查表定起点，顺数至生时
    s['铃星'] = ([10, 10, 3, 10, 10, 10, 3, 10, 10, 10, 3, 10][yZhi] + hVal) % 12;

    return s;
  }

  /// 计算杂曜位置 (物理索引 0-11)
  static Map<String, int> calculateMiscellaneousStars({
    required int lunarMonth,
    required int lunarDay,
    required int hVal,
    required int yZhi,
    required int yStem,
    required int fateIdx,
    required int bodyIdx,
    required int zuofuIdx,
    required int youbiIdx,
    required int wenchangIdx,
    required int wenquIdx,
    required bool isYangP,
  }) {
    Map<String, int> z = {};

    // ⚠️ 以下算法已将 JS的 "巳=0" 坐标系 完美映射为 Dart的 "子=0" 坐标系
    // ==========================================

    // 1. 日系杂曜 (相对位移，无需坐标转换)
    z['三台'] = (zuofuIdx + lunarDay - 1) % 12;
    z['八座'] = (youbiIdx - (lunarDay - 1) + 120) % 12;
    z['恩光'] = (wenchangIdx + lunarDay - 2 + 120) % 12;
    z['天贵'] = (wenquIdx + lunarDay - 2 + 120) % 12;

    // 2. 时系杂曜
    z['台辅'] = (6 + hVal) % 12; // JS 1是午, Dart 6是午
    z['封诰'] = (2 + hVal) % 12; // JS 9是寅, Dart 2是寅

    // 3. 命身联动杂曜 (相对位移)
    z['天才'] = (fateIdx + yZhi) % 12;
    z['天寿'] = (bodyIdx + yZhi) % 12;

    // 4. 生年地支系杂曜 (重点坐标系转换区)
    z['龙池'] = (4 + yZhi) % 12; // JS 11是辰, Dart 4是辰
    z['凤阁'] = (10 - yZhi + 120) % 12; // JS 5是戌, Dart 10是戌

    // 以下数组已执行 (JS数组值 + 5) % 12 的完美映射
    z['孤辰'] = [2, 2, 5, 5, 5, 8, 8, 8, 11, 11, 11, 2][yZhi];
    z['寡宿'] = [10, 4, 1, 1, 1, 4, 4, 4, 7, 7, 7, 10][yZhi];
    z['劫煞'] = [5, 2, 11, 8, 5, 2, 11, 8, 5, 2, 11, 8][yZhi];

    // 大耗：根据你的 JS 逻辑重写为 Dart 数组映射
    z['大耗'] = [7, 6, 9, 8, 11, 10, 1, 0, 3, 2, 5, 4][yZhi];

    z['蜚廉'] = [8, 9, 10, 5, 6, 7, 2, 3, 4, 11, 0, 1][yZhi];
    z['破碎'] = [5, 1, 9, 5, 1, 9, 5, 1, 9, 5, 1, 9][yZhi];
    z['华盖'] = [4, 1, 10, 7, 4, 1, 10, 7, 4, 1, 10, 7][yZhi];
    z['咸池'] = [9, 6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0][yZhi];

    z['龙德'] = (7 + yZhi) % 12; // JS 2是未, Dart 7是未
    z['月德'] = (5 + yZhi) % 12; // JS 0是巳, Dart 5是巳
    z['天德'] = (9 + yZhi) % 12; // JS 4是酉, Dart 9是酉
    z['年解'] = (10 - yZhi + 120) % 12; // JS 5是戌, Dart 10是戌

    const tianmaMap = {
      0: 2,
      4: 2,
      8: 2,
      2: 8,
      6: 8,
      10: 8,
      11: 5,
      3: 5,
      7: 5,
      5: 11,
      9: 11,
      1: 11,
    };
    z['天马'] = tianmaMap[yZhi]!;

    // JS 的天空逻辑映射过来刚好等于下一年支
    z['天空'] = (yZhi + 1) % 12;

    z['红鸾'] = (3 - yZhi + 120) % 12; // JS 10是卯, Dart 3是卯
    z['天喜'] = (z['红鸾']! + 6) % 12;
    z['天哭'] = (6 - yZhi + 120) % 12; // JS 1是午, Dart 6是午
    z['天虚'] = (6 + yZhi) % 12;

    // 5. 天干系杂曜
    z['天官'] = [7, 4, 5, 2, 3, 9, 11, 9, 10, 6][yStem];
    z['天福'] = [9, 8, 0, 11, 3, 2, 6, 5, 6, 5][yStem];
    z['天厨'] = [5, 6, 0, 5, 6, 8, 2, 6, 9, 11][yStem];

    z['截空'] = [8, 7, 4, 3, 0, 9, 6, 5, 2, 1][yStem];
    z['副截'] = [9, 6, 5, 2, 1, 8, 7, 4, 3, 0][yStem];

    // 旬空逻辑利用原生推导更简洁，无需 hardcode 数组
    int xunD = (yZhi - yStem + 12) % 12;
    int x1 = (xunD + 10) % 12;
    int x2 = (xunD + 11) % 12;
    z['旬空'] = yStem % 2 == 0 ? x1 : x2;
    z['副旬'] = yStem % 2 == 0 ? x2 : x1;

    // 6. 月系杂曜
    z['天刑'] = (9 + lunarMonth - 1) % 12; // JS 4是酉, Dart 9是酉
    z['天姚'] = (1 + lunarMonth - 1) % 12; // JS 8是丑, Dart 1是丑
    z['解神'] = [8, 8, 10, 10, 0, 0, 2, 2, 4, 4, 6, 6][lunarMonth - 1];
    z['天巫'] = [5, 8, 2, 11][(lunarMonth - 1) % 4];
    z['天月'] = [10, 5, 4, 2, 7, 3, 11, 7, 2, 6, 10, 2][lunarMonth - 1];
    z['阴煞'] = [2, 0, 10, 8, 6, 4][(lunarMonth - 1) % 6];

    // 7. 宫位系杂曜 (相对位移)
    int friendsPalace = (fateIdx - 7 + 12) % 12;
    int healthPalace = (fateIdx - 5 + 12) % 12;
    if (isYangP) {
      z['天伤'] = friendsPalace;
      z['天使'] = healthPalace;
    } else {
      z['天伤'] = healthPalace;
      z['天使'] = friendsPalace;
    }

    return z;
  }

  static int _getBureauValue(String bureau) {
    if (bureau.contains("二")) return 2;
    if (bureau.contains("三")) return 3;
    if (bureau.contains("四")) return 4;
    if (bureau.contains("五")) return 5;
    if (bureau.contains("六")) return 6;
    return 2;
  }

  static const Map<String, List<String>> _brightnessDict = {
    "紫微": ["平", "庙", "庙", "旺", "陷", "旺", "庙", "庙", "旺", "平", "闲", "旺"],
    "天机": ["庙", "陷", "旺", "旺", "庙", "平", "庙", "陷", "平", "旺", "庙", "平"],
    "太阳": ["陷", "陷", "旺", "庙", "旺", "旺", "庙", "平", "闲", "闲", "陷", "陷"],
    "武曲": ["旺", "庙", "闲", "陷", "庙", "平", "旺", "庙", "平", "旺", "庙", "平"],
    "天同": ["旺", "陷", "闲", "庙", "平", "庙", "陷", "陷", "旺", "平", "平", "庙"],
    "廉贞": ["平", "旺", "庙", "闲", "旺", "陷", "平", "庙", "庙", "平", "旺", "陷"],
    "天府": ["庙", "庙", "庙", "平", "庙", "平", "旺", "庙", "平", "陷", "庙", "旺"],
    "太阴": ["庙", "庙", "闲", "陷", "闲", "陷", "陷", "平", "平", "旺", "旺", "庙"],
    "贪狼": ["旺", "庙", "平", "地", "庙", "陷", "旺", "庙", "平", "平", "庙", "陷"],
    "巨门": ["旺", "旺", "庙", "庙", "平", "平", "旺", "陷", "庙", "庙", "旺", "旺"],
    "天相": ["庙", "庙", "庙", "陷", "旺", "平", "旺", "闲", "庙", "陷", "闲", "平"],
    "天梁": ["庙", "旺", "庙", "庙", "旺", "陷", "庙", "旺", "陷", "地", "旺", "陷"],
    "七杀": ["旺", "庙", "庙", "陷", "旺", "平", "旺", "旺", "庙", "闲", "庙", "平"],
    "破军": ["庙", "旺", "陷", "旺", "旺", "平", "庙", "旺", "陷", "陷", "旺", "平"],
    "文昌": ["旺", "庙", "陷", "平", "旺", "庙", "陷", "平", "旺", "庙", "陷", "旺"],
    "文曲": ["庙", "庙", "平", "旺", "庙", "庙", "陷", "旺", "平", "庙", "陷", "旺"],
    "左辅": ["旺", "庙", "庙", "陷", "庙", "平", "旺", "庙", "平", "陷", "庙", "闲"],
    "右弼": ["庙", "庙", "旺", "陷", "庙", "平", "旺", "庙", "闲", "陷", "庙", "平"],
    "天魁": ["旺", "旺", "闲", "庙", "平", "平", "庙", "庙", "旺", "旺", "平", "旺"],
    "天钺": ["旺", "旺", "旺", "平", "旺", "旺", "旺", "旺", "庙", "庙", "旺", "庙"],
    "擎羊": ["陷", "庙", "闲", "陷", "庙", "闲", "平", "庙", "闲", "陷", "庙", "闲"],
    "陀罗": ["闲", "庙", "陷", "闲", "庙", "陷", "闲", "庙", "陷", "闲", "庙", "陷"],
    "火星": ["平", "旺", "庙", "平", "闲", "旺", "庙", "闲", "陷", "陷", "庙", "平"],
    "铃星": ["陷", "陷", "庙", "庙", "旺", "旺", "庙", "旺", "旺", "陷", "庙", "庙"],
    "地劫": ["陷", "陷", "平", "平", "陷", "闲", "庙", "平", "庙", "平", "平", "旺"],
    "地空": ["平", "陷", "陷", "平", "陷", "庙", "庙", "平", "庙", "庙", "陷", "陷"],
    "禄存": ["旺", "地", "庙", "旺", "地", "庙", "旺", "地", "庙", "旺", "地", "庙"],
    "天马": ["旺", "平", "旺", "平", "旺", "平", "旺", "平", "旺", "平", "旺", "平"],
  };

  /// 获取星曜亮度
  static String? getStarBrightness(String starName, int palaceIdx) {
    if (palaceIdx < 0 || palaceIdx > 11) return null;
    return _brightnessDict[starName]?[palaceIdx];
  }

  static Map<String, int> calculateChangSheng12({
    required String bureau,
    required String genderTag,
  }) {
    final names = [
      "长生",
      "沐浴",
      "冠带",
      "临官",
      "帝旺",
      "衰",
      "病",
      "死",
      "墓",
      "绝",
      "胎",
      "养",
    ];
    int startIdx = 0;

    // 1. 定起点（长生所在宫位）
    // 水二局、土五局起于申(8)；木三局起于亥(11)；金四局起于巳(5)；火六局起于寅(2)
    if (bureau.contains('水') || bureau.contains('土')) {
      startIdx = 8;
    } else if (bureau.contains('木')) {
      startIdx = 11;
    } else if (bureau.contains('金')) {
      startIdx = 5;
    } else if (bureau.contains('火')) {
      startIdx = 2;
    }

    // 2. 定顺逆
    // 阳男阴女顺行 (+1)，阴男阳女逆行 (-1)
    bool isForward = genderTag == '阳男' || genderTag == '阴女';

    // 3. 排布十二神
    Map<String, int> result = {};
    for (int i = 0; i < 12; i++) {
      int pos = isForward ? (startIdx + i) % 12 : (startIdx - i + 12) % 12;
      result[names[i]] = pos;
    }

    return result;
  }

  /// 🆕 第七阶段：计算指定物理宫位的大限岁数区间
  /// [targetIdx] 当前需要计算的物理宫位索引 (0-11)
  /// [lifeIdx] 命宫所在的物理宫位索引 (0-11)
  /// [bureau] 五行局，例如 "水二局"
  /// [genderTag] 阴阳性别，例如 "阳男", "阴女"
  /// 返回：大限区间字符串，例如 "2-11" 或 "12-21"
  static String getDaXianRange({
    required int targetIdx,
    required int lifeIdx,
    required String bureau,
    required String genderTag,
  }) {
    // 1. 定起局基础岁数
    int baseAge = 2;
    if (bureau.contains('水'))
      baseAge = 2;
    else if (bureau.contains('木'))
      baseAge = 3;
    else if (bureau.contains('金'))
      baseAge = 4;
    else if (bureau.contains('土'))
      baseAge = 5;
    else if (bureau.contains('火'))
      baseAge = 6;

    // 2. 定顺逆 (阳男阴女顺行，阴男阳女逆行)
    bool isForward = genderTag == '阳男' || genderTag == '阴女';

    // 3. 计算当前宫位距离命宫的“步数”
    int steps = 0;
    if (isForward) {
      steps = (targetIdx - lifeIdx + 12) % 12; // 顺时针距离
    } else {
      steps = (lifeIdx - targetIdx + 12) % 12; // 逆时针距离
    }

    // 4. 计算大限始终岁数
    int startAge = baseAge + (steps * 10);
    int endAge = startAge + 9;

    return "$startAge-$endAge";
  }
  // ==========================================
  // 🆕 第八阶段：动态流年/流月定位计算
  // ==========================================

  /// 计算流年命宫物理索引
  /// [liuNianZhi] 流年地支，如 2024 甲辰年传入 '辰'
  static int getLiuNianPalaceIdx(String liuNianZhi) {
    const zhis = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    return zhis.indexOf(liuNianZhi);
  }

  /// 🆕 新增：独立计算斗君所在的物理宫位索引 (即流年正月所在宫位)
  static int getDouJunPalaceIdx({
    required int liuNianIdx,
    required int birthMonth,
    required int birthHourIdx,
  }) {
    int safeBirth = birthMonth.abs();
    // 月退时进
    int yueTuiIdx = (liuNianIdx - (safeBirth - 1) + 12) % 12;
    int douJunIdx = (yueTuiIdx + birthHourIdx) % 12;
    return douJunIdx;
  }

  /// 计算流月命宫物理索引 (基于斗君法)
  /// [liuNianIdx] 流年命宫物理索引 (0-11)
  /// [birthMonth] 农历出生月份 (1-12)
  /// [birthHourIdx] 出生时辰索引 (0=子时, 1=丑时...)
  /// [targetMonth] 目标查询的流月 (1-12，如遇闰月传绝对值)
  static int getLiuYuePalaceIdx({
    required int liuNianIdx,
    required int birthMonth,
    required int birthHourIdx,
    required int targetMonth,
  }) {
    // 确保输入的月份是正数（lunar 库的闰月会返回负数，如闰6月返回 -6。紫微斗数排盘一般将闰月当月算或拆分算，此处基础算法取绝对值兜底）
    int safeTarget = targetMonth.abs();
    int safeBirth = birthMonth.abs();

    // 1. 从流年命宫起正月，逆数至出生月份
    int step1 = (liuNianIdx - (safeBirth - 1) + 12) % 12;
    // 2. 顺数至出生时辰，得出“斗君”（流年正月）
    int douJunIdx = (step1 + birthHourIdx) % 12;
    // 3. 从斗君顺数至目标流月
    int liuYueIdx = (douJunIdx + (safeTarget - 1)) % 12;

    return liuYueIdx;
  }
  // ==========================================
  // 第九阶段：新增杂曜与命身主计算
  // ==========================================

  /// 1. 太岁十二神 (起于流年地支，顺行)
  static Map<String, int> calculateTaiSui12(int yZhi) {
    const names = [
      "太岁",
      "晦气",
      "丧门",
      "贯索",
      "官符",
      "小耗",
      "岁破",
      "龙德",
      "白虎",
      "天德",
      "吊客",
      "病符",
    ];
    Map<String, int> res = {};
    for (int i = 0; i < 12; i++) {
      res[names[i]] = (yZhi + i) % 12;
    }
    return res;
  }

  /// 2. 博士十二神 (起于禄存，顺逆由阴阳性别决定)
  static Map<String, int> calculateDoctor12(int luCunIdx, String genderTag) {
    const names = [
      "博士",
      "力士",
      "青龙",
      "小耗",
      "将军",
      "奏书",
      "飞廉",
      "喜神",
      "病符",
      "大耗",
      "伏兵",
      "官符",
    ];
    bool isForward = genderTag == '阳男' || genderTag == '阴女';
    Map<String, int> res = {};
    for (int i = 0; i < 12; i++) {
      int pos = isForward ? (luCunIdx + i) % 12 : (luCunIdx - i + 12) % 12;
      res[names[i]] = pos;
    }
    return res;
  }

  /// 3. 将前诸星 (起于年支三合长生位，顺行)
  static Map<String, int> calculateGeneral12(int yZhi) {
    const names = [
      "将星",
      "攀鞍",
      "岁驿",
      "息神",
      "华盖",
      "劫煞",
      "灾煞",
      "天煞",
      "指背",
      "咸池",
      "月煞",
      "亡神",
    ];
    int startIdx = 0;
    if ([8, 0, 4].contains(yZhi))
      startIdx = 0; // 申子辰年起申
    else if ([2, 6, 10].contains(yZhi))
      startIdx = 6; // 寅午戌年起寅
    else if ([11, 3, 7].contains(yZhi))
      startIdx = 3; // 亥卯未年起亥
    else
      startIdx = 9; // 巳酉丑年起巳

    Map<String, int> res = {};
    for (int i = 0; i < 12; i++) {
      res[names[i]] = (startIdx + i) % 12;
    }
    return res;
  }

  /// 4. 命主 & 身主
  static String getLifeLord(int fateIdx) {
    const lords = [
      "贪狼",
      "巨门",
      "禄存",
      "文曲",
      "廉贞",
      "武曲",
      "破军",
      "武曲",
      "廉贞",
      "文曲",
      "禄存",
      "巨门",
    ];
    return lords[fateIdx % 12];
  }

  static String getBodyLord(int yZhi) {
    const lords = [
      "火星",
      "天相",
      "天梁",
      "天同",
      "文昌",
      "天机",
      "火星",
      "天相",
      "天梁",
      "天同",
      "文昌",
      "天机",
    ];
    return lords[yZhi % 12];
  }
}
