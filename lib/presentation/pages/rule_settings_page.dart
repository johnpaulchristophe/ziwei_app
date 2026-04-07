import 'package:flutter/material.dart';
import '../../domain/app_versions.dart';

class RuleSettingsPage extends StatelessWidget {
  const RuleSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '排盘规则与版本说明',
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('排盘基准与流派'),
          _buildCard([
            _buildRuleItem('核心流派', '三合派（中州系主导）'),
            _buildRuleItem(
              '四化取用标准',
              '遵循中州派标准四化。\n⚠️ 争议天干锁定：\n甲干：廉贞(禄) 破军(权) 武曲(科) 太阳(忌)\n戊干：贪狼(禄) 太阴(权) 太阳(科) 天机(忌)\n庚干：太阳(禄) 武曲(权) 天府(科) 天同(忌)\n辛干：巨门(禄) 太阳(权) 文曲(科) 文昌(忌)\n壬干：天梁(禄) 紫微(权) 天府(科) 武曲(忌)\n癸干：破军(禄) 巨门(权) 太阴(科) 贪狼(忌)',
            ),
          ]),

          const SizedBox(height: 20),
          _buildSectionTitle('历法与时间口径'),
          _buildCard([
            _buildRuleItem('时辰划分 (晚子时)', '23:00 - 24:00 计入当日子时。'),
            _buildRuleItem('闰月排盘规则', '闰月十五日（含）前作当月计算，十六日（含）起作下个月计算。'),
            _buildRuleItem('排盘时区设定', '采用标准时间排盘（暂未引入真太阳时与经纬度校正）。'),
          ]),

          const SizedBox(height: 20),
          _buildSectionTitle('系统版本与可信度'),
          _buildCard([
            _buildRuleItem('历史盘重算机制', '每次打开历史记录，均会基于最新版引擎重新排布，确保精度随引擎升级而自动纠偏。'),
            _buildRuleItem(
              '引擎测试认证',
              '核心算法已通过自动化金标准测试，涵盖早晚子时、闰月换月、立春边界等极端高风险场景。',
            ),
            _buildRuleItem('当前应用版本', 'v${AppVersions.appVersion}'),
            _buildRuleItem(
              '排盘规则版本',
              'v${AppVersions.engineVersion}',
              isLast: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRuleItem(String title, String content, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(color: Colors.black54, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: Colors.grey.shade100,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
