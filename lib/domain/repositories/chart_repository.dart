import '../models/saved_chart.dart';

/// 命盘存储契约
/// 将业务逻辑与底层具体的存储方案 (SharedPrefs/SQLite) 彻底隔离
abstract class ChartRepository {
  /// 保存新命盘
  Future<void> saveChart(SavedChart chart);

  /// 获取所有已保存的命盘列表
  Future<List<SavedChart>> getAllCharts();

  /// 根据 ID 删除命盘
  Future<void> deleteChart(String id);

  /// 重命名命盘
  Future<void> renameChart(String id, String newTitle);
}
