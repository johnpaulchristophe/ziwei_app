import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart'; // 确保路径正确，指向你的 provider 文件
import '../../domain/models/models.dart';
import '../../domain/models/saved_chart.dart';
import '../../infrastructure/storage/shared_prefs_chart_repository.dart';
import 'chart_page.dart';
// ⚠️ 注意：这里需要引入你实际负责排盘计算的引擎类 (比如 ZiweiMapper 或计算逻辑文件)
// import '../../domain/logic/ziwei_mapper.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _repository = SharedPrefsChartRepository();
  List<SavedChart> _charts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharts();
  }

  Future<void> _loadCharts() async {
    setState(() => _isLoading = true);
    try {
      final charts = await _repository.getAllCharts();
      setState(() {
        _charts = charts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('读取失败: $e')));
      }
    }
  }

  // 重命名弹窗逻辑
  Future<void> _renameChart(SavedChart chart) async {
    final controller = TextEditingController(text: chart.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名命盘', style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(isDense: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty && newTitle != chart.title) {
      await _repository.renameChart(chart.id, newTitle);
      _loadCharts(); // 刷新列表
    }
  }

  // 删除逻辑
  Future<void> _deleteChart(String id) async {
    await _repository.deleteChart(id);
    _loadCharts(); // 刷新列表
  }

  // 统一排盘入口：复用 input_page 的生成逻辑
  void _openChart(SavedChart chart) {
    try {
      final BirthInput input = chart.birthInput;

      // 🌟 这一行就是从你的 input_page.dart 里复制过来的计算逻辑！
      final result = ref.read(engineProvider).generateChart(input);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChartPage(chart: result, birthInput: input),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('排盘失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '历史命盘',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _charts.isEmpty
          ? const Center(
              child: Text('暂无历史记录', style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              itemCount: _charts.length,
              itemBuilder: (context, index) {
                final chart = _charts[index];
                return Dismissible(
                  key: Key(chart.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteChart(chart.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        chart.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '保存时间: ${chart.createdAt.toString().split('.')[0]}\n'
                        '${chart.birthInput.year}年${chart.birthInput.month}月${chart.birthInput.day}日',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      onTap: () => _openChart(chart),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () => _renameChart(chart),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
