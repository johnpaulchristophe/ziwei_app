import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/models.dart';
import '../providers.dart';
import 'chart_page.dart';
import 'history_page.dart';
import 'rule_settings_page.dart';

class InputPage extends ConsumerStatefulWidget {
  const InputPage({super.key});

  @override
  ConsumerState<InputPage> createState() => _InputPageState();
}

class _InputPageState extends ConsumerState<InputPage> {
  // 默认初始数据
  DateTime _selectedDate = DateTime(1990, 5, 15);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30);
  Gender _gender = Gender.male;
  CalendarType _dateType = CalendarType.solar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text('紫微排盘输入'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RuleSettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white), // 用白色匹配你的暗色主题
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
        // 👆 添加结束
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. 日期选择行
          _buildInputTile(
            icon: Icons.calendar_month,
            label: '日期',
            value:
                "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),

          // 2. 时间选择行
          _buildInputTile(
            icon: Icons.access_time,
            label: '时间',
            value: _selectedTime.format(context),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (time != null) setState(() => _selectedTime = time);
            },
          ),

          const Divider(color: Colors.white10, height: 40),

          // 3. 性别选择
          Row(
            children: [
              const Icon(Icons.person, color: Colors.blueAccent),
              const SizedBox(width: 15),
              const Text('性别', style: TextStyle(color: Colors.white70)),
              const Spacer(),
              ChoiceChip(
                label: const Text('男'),
                selected: _gender == Gender.male,
                onSelected: (s) => setState(() => _gender = Gender.male),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('女'),
                selected: _gender == Gender.female,
                onSelected: (s) => setState(() => _gender = Gender.female),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 4. 历法选择
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber),
              const SizedBox(width: 15),
              const Text('历法', style: TextStyle(color: Colors.white70)),
              const Spacer(),
              DropdownButton<CalendarType>(
                value: _dateType,
                dropdownColor: const Color(0xFF2C2E31),
                style: const TextStyle(color: Colors.white),
                underline: Container(),
                items: const [
                  DropdownMenuItem(
                    value: CalendarType.solar,
                    child: Text('公历 (阳历)'),
                  ),
                  DropdownMenuItem(
                    value: CalendarType.lunar,
                    child: Text('农历 (阴历)'),
                  ),
                ],
                onChanged: (val) => setState(() => _dateType = val!),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // 5. 提交按钮
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // 构造完整的输入模型
              final input = BirthInput(
                year: _selectedDate.year,
                month: _selectedDate.month,
                day: _selectedDate.day,
                hour: _selectedTime.hour,
                minute: _selectedTime.minute,
                gender: _gender,
                dateType: _dateType,
              );

              // 调用引擎计算
              final chart = ref.read(engineProvider).generateChart(input);

              // 跳转到结果页
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartPage(
                    chart: chart, // 原有的计算结果
                    birthInput: input, // 🌟 你的原始 BirthInput 对象
                  ),
                ),
              );
            },
            child: const Text(
              '开始精准排盘',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 抽离的通用输入行组件
  Widget _buildInputTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
