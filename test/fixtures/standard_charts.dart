// ⚠️ 注意：请将这里的包名替换为你项目的实际导入路径
import '../../lib/domain/models/models.dart';
import '../../lib/domain/models/birth_input.dart';

/// 命盘基准测试用例 (金标准)
class ChartTestCase {
  final String description; // 样例描述
  final BirthInput input; // 原始输入参数

  // --- 期望的绝对正确结果 (从权威软件抄录) ---
  final String expectedFatePalaceBranch; // 命宫地支 (如: "寅")
  final String expectedBodyPalaceBranch; // 身宫地支
  final String expectedFiveElements; // 五行局 (如: "木三局")
  final String expectedZiweiBranch; // 紫微星落地支
  final List<String> expectedFateMajorStars; // 命宫主星数组 (如: ["天机", "太阴"])
  final int expectedStartDecadeAge; // 起大限岁数

  const ChartTestCase({
    required this.description,
    required this.input,
    required this.expectedFatePalaceBranch,
    required this.expectedBodyPalaceBranch,
    required this.expectedFiveElements,
    required this.expectedZiweiBranch,
    required this.expectedFateMajorStars,
    required this.expectedStartDecadeAge,
  });
}

/// 全局金标准测试集
class StandardCharts {
  static final List<ChartTestCase> testCases = [
    // ==========================================
    // 1. 标准公历盘 (对照组：验证基础排盘链路畅通)
    // ==========================================
    const ChartTestCase(
      description: "标准公历盘 (1990-05-15 10:30 男)",
      input: BirthInput(
        year: 1990,
        month: 5,
        day: 15,
        hour: 10,
        minute: 30, // 巳时
        gender: Gender.male,
        dateType: CalendarType.solar,
        isLeapMonth: false,
      ),
      // ⚠️ 以下 Expected 数据需你用文墨天机输入上述生辰后，填入真实正确值：
      expectedFatePalaceBranch: "子",
      expectedBodyPalaceBranch: "戌",
      expectedFiveElements: "火六局",
      expectedZiweiBranch: "寅",
      expectedFateMajorStars: ["破军"],
      expectedStartDecadeAge: 6,
    ),

    // ==========================================
    // 2. [P0级风险] 晚子时跨日盘 (验证天干与时辰换算边界)
    // ==========================================
    const ChartTestCase(
      description: "晚子时跨日盘 (1995-08-10 23:30 男)",
      input: BirthInput(
        year: 1995,
        month: 8,
        day: 10,
        hour: 23,
        minute: 30, // 晚子时 (23:00 - 23:59)
        gender: Gender.male,
        dateType: CalendarType.solar,
        isLeapMonth: false,
      ),
      // ⚠️ 以下是验证晚子时算法的核心：
      // 这里的预期结果，必须是你决定采用的流派（如：算作11日的子时，但天干维持10日/或进位）所对应的正确结果！
      expectedFatePalaceBranch: "申", // 待核对填入
      expectedBodyPalaceBranch: "申", // 待核对填入
      expectedFiveElements: "水二局", // 待核对填入
      expectedZiweiBranch: "申", // 待核对填入
      expectedFateMajorStars: ["紫微", "天府"], // 待核对填入
      expectedStartDecadeAge: 2, // 待核对填入
    ),

    // 后续我们将继续补充：闰月盘、立春交界盘...
    // ==========================================
    // 3. [P0级风险] 闰月盘 (验证闰月分界或当月逻辑)
    // 危险点：2006年有闰七月。排盘引擎是否正确处理了闰月（如：按十五日划分，或直接作八月算）。
    // ==========================================
    const ChartTestCase(
      description: "闰月分界盘 (2006-09-08 14:30 女)",
      input: BirthInput(
        year: 2006,
        month: 9,
        day: 8,
        hour: 14,
        minute: 30, // 未时
        gender: Gender.female,
        dateType: CalendarType.solar, // 公历 2006-09-08 对应农历 丙戌年 闰七月十六
        isLeapMonth: false,
      ),
      // ⚠️ 预期结果请用文墨天机输入 "公历 2006年9月8日 14:30" 查阅后填入：
      expectedFatePalaceBranch: "寅", // 待核对填入
      expectedBodyPalaceBranch: "辰", // 待核对填入
      expectedFiveElements: "木三局", // 待核对填入
      expectedZiweiBranch: "酉", // 待核对填入
      expectedFateMajorStars: [], // 待核对填入
      expectedStartDecadeAge: 3, // 待核对填入
    ),

    // ==========================================
    // 4. [P1级风险] 节气边界盘 (验证紫微只看正月初一，不看立春)
    // 危险点：2022-02-02 (农历正月初二)。此时还未到立春(2月4日)。
    // 八字算辛丑年，紫微必须算壬寅年！天干绝不能错排为辛干。
    // ==========================================
    const ChartTestCase(
      description: "立春前换年盘 (2022-02-02 08:30 男)",
      input: BirthInput(
        year: 2022,
        month: 2,
        day: 2,
        hour: 8,
        minute: 30, // 辰时
        gender: Gender.male,
        dateType: CalendarType.solar,
        isLeapMonth: false,
      ),
      // ⚠️ 预期结果请用文墨天机输入查阅后填入 (注意看是不是壬寅年的天干排布)：
      expectedFatePalaceBranch: "戌", // 待核对填入
      expectedBodyPalaceBranch: "午", // 待核对填入
      expectedFiveElements: "金四局", // 待核对填入
      expectedZiweiBranch: "辰", // 待核对填入
      expectedFateMajorStars: ["破军"], // 待核对填入
      expectedStartDecadeAge: 4, // 待核对填入
    ),

    // ==========================================
    // 5. [P2级风险] 阴阳逆行盘 (验证大限顺逆)
    // 危险点：阴男（生年干为阴，如乙、丁、己、辛、癸），大限必须逆行。
    // ==========================================
    const ChartTestCase(
      description: "阴男逆行盘 (1993-06-15 12:30 男)",
      input: BirthInput(
        year: 1993,
        month: 6,
        day: 15,
        hour: 12,
        minute: 30, // 午时
        gender: Gender.male,
        dateType: CalendarType.solar, // 癸酉年 (阴男)
        isLeapMonth: false,
      ),
      expectedFatePalaceBranch: "亥", // 待核对填入
      expectedBodyPalaceBranch: "亥", // 待核对填入
      expectedFiveElements: "水二局", // 待核对填入
      expectedZiweiBranch: "寅", // 待核对填入
      expectedFateMajorStars: ["太阳"], // 待核对填入
      expectedStartDecadeAge: 2, // 待核对填入
    ),
  ];
}
