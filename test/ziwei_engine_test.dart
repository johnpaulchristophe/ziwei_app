import 'package:flutter_test/flutter_test.dart';
import 'package:ziwei_app/domain/models/models.dart';
import 'package:ziwei_app/domain/logic/star_calculators.dart';
import 'package:ziwei_app/domain/logic/divination_calculators.dart';
import 'package:lunar/lunar.dart'; // 别忘了在测试文件顶部也引入

void main() {
  // ==========================================
  // 第五阶段：亮度字典测试
  // ==========================================
  group('StarCalculators 亮度映射测试', () {
    test('正常输入：正确映射主辅星亮度', () {
      expect(StarCalculators.getStarBrightness('紫微', 0), '平');
      expect(StarCalculators.getStarBrightness('太阳', 3), '庙');
    });

    test('空值/非法输入：未收录的星曜应返回 null', () {
      expect(StarCalculators.getStarBrightness('不存在的星', 0), isNull);
    });
  });

  // ==========================================
  // 第六阶段：旁路断语测试 (高鲁棒性关键字匹配)
  // ==========================================
  group('DivinationCalculators 旁路断语测试', () {
    test('贪狼入子宫 + 火铃空劫 真实文档规则命中测试', () {
      final mockPalace = Palace(
        index: 0, // 子宫
        name: '命宫',
        earthlyBranch: '丙子',
        majorStars: [Star(name: '贪狼')],
        minorStars: [
          Star(name: '铃星'),
          Star(name: '地劫'),
        ],
      );

      final result = DivinationCalculators.getCommentariesForPalace(mockPalace);

      // 【高级测试技巧】：将长文本拼接为单行，使用关键字模糊匹配
      // 彻底解决因为全半角标点、换行符差异导致的测试误报
      final allText = result.join(' || ');

      expect(result.isNotEmpty, isTrue, reason: '引擎不应返回空列表');
      expect(allText.contains('贪狼独坐'), isTrue, reason: '应命中独坐基础特征');
      expect(allText.contains('铃贪格'), isTrue, reason: '应命中子宫专属的铃贪格特征');
      expect(allText.contains('烟酒嗜好'), isTrue, reason: '应命中见煞曜的通用特征');
    });

    test('非命宫不触发断语，应返回空列表', () {
      final emptyPalace = Palace(
        index: 1,
        name: '兄弟',
        earthlyBranch: '丁丑',
        majorStars: [],
        minorStars: [Star(name: '左辅')],
      );

      final result = DivinationCalculators.getCommentariesForPalace(
        emptyPalace,
      );
      expect(result, isEmpty);
    });
  });

  // ==========================================
  // 第七阶段：长生十二神排布测试
  // ==========================================
  group('StarCalculators 长生十二神引擎测试', () {
    test('水二局 + 阳男 (申宫起长生，顺行)', () {
      final res = StarCalculators.calculateChangSheng12(
        bureau: '水二局',
        genderTag: '阳男',
      );
      expect(res['长生'], 8);
      expect(res['沐浴'], 9);
      expect(res['帝旺'], 0);
    });

    test('火六局 + 阴男 (寅宫起长生，逆行)', () {
      final res = StarCalculators.calculateChangSheng12(
        bureau: '火六局',
        genderTag: '阴男',
      );
      expect(res['长生'], 2);
      expect(res['沐浴'], 1);
      expect(res['养'], 3);
    });
  });

  // ==========================================
  // 第七阶段：大限区间顺逆排布测试
  // ==========================================
  group('StarCalculators 大限区间排布测试', () {
    test('水二局 + 阳男 (命宫子位, 顺行)', () {
      expect(
        StarCalculators.getDaXianRange(
          targetIdx: 0,
          lifeIdx: 0,
          bureau: '水二局',
          genderTag: '阳男',
        ),
        '2-11',
      );
      expect(
        StarCalculators.getDaXianRange(
          targetIdx: 1,
          lifeIdx: 0,
          bureau: '水二局',
          genderTag: '阳男',
        ),
        '12-21',
      );
    });

    test('火六局 + 阴男 (命宫寅位, 逆行跨越)', () {
      expect(
        StarCalculators.getDaXianRange(
          targetIdx: 2,
          lifeIdx: 2,
          bureau: '火六局',
          genderTag: '阴男',
        ),
        '6-15',
      );
      expect(
        StarCalculators.getDaXianRange(
          targetIdx: 1,
          lifeIdx: 2,
          bureau: '火六局',
          genderTag: '阴男',
        ),
        '16-25',
      );
      expect(
        StarCalculators.getDaXianRange(
          targetIdx: 3,
          lifeIdx: 2,
          bureau: '火六局',
          genderTag: '阴男',
        ),
        '116-125',
      );
    });
  });
  // ==========================================
  // 第八阶段：真农历依赖引擎测试
  // ==========================================
  group('真农历流年流月边界测试', () {
    test('春节前后的跨年错位验证 (2024年春节是2月10日)', () {
      // 1. 公历 2024-02-09 (除夕)，此时农历仍是【癸卯】年
      final date1 = DateTime(2024, 2, 9);
      final lunar1 = Lunar.fromDate(date1);
      expect(lunar1.getYearZhi(), '卯', reason: '除夕仍属卯年');
      expect(StarCalculators.getLiuNianPalaceIdx(lunar1.getYearZhi()), 3); // 卯宫

      // 2. 公历 2024-02-10 (正月初一)，此时农历正式跨入【甲辰】年
      final date2 = DateTime(2024, 2, 10);
      final lunar2 = Lunar.fromDate(date2);
      expect(lunar2.getYearZhi(), '辰', reason: '正月初一进入辰年');
      expect(StarCalculators.getLiuNianPalaceIdx(lunar2.getYearZhi()), 4); // 辰宫
    });

    test('斗君法处理闰月容错验证', () {
      // 假设当前是闰6月 (lunar 库返回 -6)
      final res = StarCalculators.getLiuYuePalaceIdx(
        liuNianIdx: 4, // 辰年
        birthMonth: 6,
        birthHourIdx: 4, // 辰时
        targetMonth: -6, // 闰月输入
      );
      // 引擎底层已对 -6 取绝对值，等同于按本月（6月）正常推演斗君
      expect(res, 8); // 申宫
    });
  });
}
