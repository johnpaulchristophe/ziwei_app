import 'birth_input.dart'; // 引入你的 BirthInput

/// 历史命盘聚合根
/// 严格持有核心领域模型 BirthInput，将元数据与核心入参分离
class SavedChart {
  final String id;
  String title;
  final DateTime createdAt;
  DateTime updatedAt;
  final BirthInput birthInput; // 严格持有强类型领域模型

  SavedChart({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.birthInput,
  });

  // 落库边界：转换为基础 Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      // 委托给 BirthInput (经由 freezed 生成的 toJson)
      'birthInput': birthInput.toJson(),
    };
  }

  // 恢复边界：从基础 Map 恢复为强类型对象
  factory SavedChart.fromJson(Map<String, dynamic> json) {
    return SavedChart(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      // 委托给 BirthInput (经由 freezed 生成的 fromJson)
      birthInput: BirthInput.fromJson(
        json['birthInput'] as Map<String, dynamic>,
      ),
    );
  }
}
