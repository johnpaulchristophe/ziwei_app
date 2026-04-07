import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/saved_chart.dart';
import '../../domain/repositories/chart_repository.dart';
import 'package:flutter/foundation.dart';

/// 基于 SharedPreferences 的过渡型本地存储实现
/// 后续如果要换成 SQLite/Hive，新建一个类实现 ChartRepository 即可，不用改上层代码
class SharedPrefsChartRepository implements ChartRepository {
  static const String _storageKey = 'ziwei_saved_charts';

  @override
  Future<void> saveChart(SavedChart chart) async {
    final prefs = await SharedPreferences.getInstance();
    final List<SavedChart> charts = await getAllCharts();

    // 默认将新命盘插入到最前面，天然实现“按创建时间降序”
    charts.insert(0, chart);

    // 序列化为 JSON 字符串列表
    final List<String> jsonStringList = charts
        .map((c) => jsonEncode(c.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, jsonStringList);
  }

  @override
  Future<List<SavedChart>> getAllCharts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonStringList = prefs.getStringList(_storageKey);

      if (jsonStringList == null || jsonStringList.isEmpty) {
        return [];
      }

      List<SavedChart> validCharts = [];

      // 🌟 RC 核心兜底 1：拆解 map，实施坏数据隔离
      for (String jsonStr in jsonStringList) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
          validCharts.add(SavedChart.fromJson(jsonMap));
        } catch (e) {
          // ⚠️ 如果某个旧盘解析报错，我们直接把它“吃掉”并跳过
          // 绝不允许一颗老鼠屎坏了一锅汤
          debugPrint('RC 兜底拦截 - 解析旧历史盘失败跳过: $e');
        }
      }

      return validCharts;
    } catch (e) {
      // 🌟 RC 核心兜底 2：SharedPreferences 整体读取崩溃（如手机存储空间损坏）
      debugPrint('RC 兜底拦截 - 读取历史记录整体失败: $e');
      // 就算天塌下来，也要返回一个空数组，保证 UI 层不白屏
      return [];
    }
  }

  @override
  Future<void> deleteChart(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<SavedChart> charts = await getAllCharts();

    // 移除对应 ID 的记录
    charts.removeWhere((chart) => chart.id == id);

    final List<String> jsonStringList = charts
        .map((c) => jsonEncode(c.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, jsonStringList);
  }

  @override
  Future<void> renameChart(String id, String newTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final List<SavedChart> charts = await getAllCharts();

    final index = charts.indexWhere((chart) => chart.id == id);
    if (index != -1) {
      charts[index].title = newTitle;
      charts[index].updatedAt = DateTime.now(); // 更新修改时间

      final List<String> jsonStringList = charts
          .map((c) => jsonEncode(c.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, jsonStringList);
    }
  }
}
