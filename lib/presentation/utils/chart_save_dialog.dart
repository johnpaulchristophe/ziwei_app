import 'package:flutter/material.dart';
import '../../domain/models/models.dart'; // 包含 BirthInput
import '../../domain/models/saved_chart.dart';
import '../../infrastructure/storage/shared_prefs_chart_repository.dart';

/// 独立的保存交互流程
/// 保持页面 UI 纯净，将业务与提示收口在这里
Future<void> showSaveChartDialog(
  BuildContext context,
  BirthInput birthInput,
) async {
  final TextEditingController controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '保存命盘',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '请输入命盘名称 (如：张三、自己)',
            hintStyle: const TextStyle(color: Colors.black26),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            Navigator.pop(context, value.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // 取消按钮返回 null
            child: const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // 🌟 修复：去掉 isNotEmpty 拦截，无条件返回文本（哪怕是空的）
              Navigator.pop(context, controller.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('保存'),
          ),
        ],
      );
    },
  );

  // 用户点击保存并输入了名字
  if (result != null) {
    // 🌟 新增兜底逻辑：去除前后空格，如果为空则自动赋默认值
    String finalTitle = result.trim();
    if (finalTitle.isEmpty) {
      finalTitle = '未命名命盘';
    }

    try {
      final chart = SavedChart(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // 极简唯一 ID
        title: finalTitle, // 🌟 这里替换成兜底处理过的 finalTitle
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        birthInput: birthInput,
      );
      final repository = SharedPrefsChartRepository();
      await repository.saveChart(chart);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('命盘已成功保存'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
