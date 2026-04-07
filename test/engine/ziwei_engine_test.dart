import 'package:flutter_riverpod/flutter_riverpod.dart';
// ⚠️ 注意：这里的路径要指向你实际存放 engineProvider 的文件
import '../../lib/presentation/providers.dart';
import 'package:flutter_test/flutter_test.dart';
// ⚠️ 注意：请替换为你实际的 fixtures 和引擎路径
import '../fixtures/standard_charts.dart';
// import '../../lib/domain/logic/ziwei_engine.dart'; // 你的排盘引擎或 Mapper

void main() {
  group('【核心排盘引擎】高风险规则精度与回归测试', () {
    // 遍历所有金标准测试用例
    for (final testCase in StandardCharts.testCases) {
      test(testCase.description, () {
        // ==========================================
        // 1. 执行排盘 (ACT)
        // ==========================================
        // ⚠️ 请将下面这行替换为你实际调用引擎排盘的代码
        // final result = ZiweiEngine().generateChart(testCase.input);
        // ==========================================
        // 1. 执行排盘 (ACT)
        // ==========================================
        // 使用 ProviderContainer 模拟 Riverpod 环境
        final container = ProviderContainer();
        final result = container
            .read(engineProvider)
            .generateChart(testCase.input);

        // ==========================================
        // 2. 断言验证 (ASSERT)
        // ==========================================
        expect(result, isNotNull, reason: '排盘结果不能为 null');

        // 寻找命宫和身宫
        final fatePalace = result.palaces.firstWhere(
          (p) => p.name.contains('命宫'),
        );
        final bodyPalace = result.palaces.firstWhere((p) => p.isBodyPalace);

        // [验证项 1] 命宫地支定位
        expect(
          fatePalace.earthlyBranch.split('').last,
          testCase.expectedFatePalaceBranch,
          reason: '【命宫地支定位错误】',
        );

        // [验证项 2] 身宫地支定位
        expect(
          bodyPalace.earthlyBranch.split('').last,
          testCase.expectedBodyPalaceBranch,
          reason: '【身宫地支定位错误】',
        );

        // [验证项 3] 五行局
        expect(
          result.fiveElements,
          testCase.expectedFiveElements,
          reason: '【五行局计算错误】',
        );

        // [验证项 4] 起大限岁数
        final decadeStart =
            int.tryParse(fatePalace.daXianRange.split('-').first) ?? 0;
        expect(
          decadeStart,
          testCase.expectedStartDecadeAge,
          reason: '【起大限岁数错误】',
        );

        // [验证项 5] 紫微星落宫定位
        final ziweiPalace = result.palaces.firstWhere(
          (p) => p.majorStars.any((s) => s.name == '紫微'),
        );
        expect(
          ziweiPalace.earthlyBranch.split('').last,
          testCase.expectedZiweiBranch,
          reason: '【紫微星落宫定位错误】',
        );

        // [验证项 6] 命宫主星排布
        final fateMajorStarNames = fatePalace.majorStars
            .map((s) => s.name)
            .toList();
        // 比较两个数组是否包含相同的星曜（忽略顺序）
        expect(
          fateMajorStarNames.toSet().containsAll(
            testCase.expectedFateMajorStars,
          ),
          isTrue,
          reason:
              '【命宫主星排布错误】预期: ${testCase.expectedFateMajorStars}, 实际: $fateMajorStarNames',
        );
        expect(
          testCase.expectedFateMajorStars.toSet().containsAll(
            fateMajorStarNames,
          ),
          isTrue,
          reason: '【命宫主星排布错误】实际排出了多余的主星: $fateMajorStarNames',
        );
      });
    }
  });
}
