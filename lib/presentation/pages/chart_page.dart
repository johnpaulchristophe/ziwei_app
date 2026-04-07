import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../../domain/logic/divination_calculators.dart';
import '../widgets/palace_cell.dart';
import '../utils/chart_save_dialog.dart';
import 'share_preview_page.dart';

// 注意：这里不再需要引入 lunar 库，也不需要引入 star_calculators
// 因为所有的动态推导都已经被 ZiweiMapper 接管了！

class ChartPage extends StatefulWidget {
  final ChartResult chart;
  final BirthInput birthInput; // 🌟 必须持有原始输入参数才能保存

  const ChartPage({super.key, required this.chart, required this.birthInput});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // ==========================================
  // 1. 图层状态管理
  // ==========================================
  bool _showExtended = false;
  bool _showTwelveGods = false; // 🆕 新增：四大神煞独立开关
  bool _showDynamic = false;
  bool _showCommentary = false;

  final List<int?> gridMap = [
    5,
    6,
    7,
    8,
    4,
    null,
    null,
    9,
    3,
    null,
    null,
    10,
    2,
    1,
    0,
    11,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // 🌟 稍微淡一点的背景色，提升质感，凸显宫格白底
      appBar: AppBar(
        title: const Text(
          '命盘预览',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 🌟 彻底去掉阴影，压平顶部视觉
        centerTitle: true,
        // 🌟 3. 在这里加入保存按钮
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharePreviewPage(
                    chart: widget.chart,
                    birthInput: widget.birthInput,
                    showExtended: _showExtended,
                    showTwelveGods: _showTwelveGods,
                    showDynamic: _showDynamic, // 🌟 把当前页面的流年开关状态传给导出页
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.bookmark_add_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              // 触发独立封装的保存逻辑
              showSaveChartDialog(context, widget.birthInput);
            },
          ),
        ],
        // 🌟 核心微调：在 AppBar 底部直接加一条细线，区分控制区
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: Column(
        children: [
          _buildLayerToggles(),
          // 🌟 在控制栏下方加一个极细的线，增加层次感但不占物理高度
          Divider(height: 1, color: Colors.grey.shade200),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Stack(
                // 🌟 1. 用 Stack 图层包裹，打通空间
                children: [
                  // 底层：12宫格网格
                  GridView.builder(
                    padding: const EdgeInsets.only(top: 2),
                    physics: const ClampingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                    itemCount: 16,
                    itemBuilder: (context, gridIdx) {
                      final palaceIdx = gridMap[gridIdx];
                      if (palaceIdx == null) {
                        // 🌟 2. 中间的4个格子（5,6,9,10）全部作为透明占位符
                        return const SizedBox();
                      }
                      return _buildPalaceCell(palaceIdx);
                    },
                  ),

                  // 顶层：中宫独立图层
                  Center(
                    // 🌟 3. 让中宫悬浮在正中央
                    child: FractionallySizedBox(
                      widthFactor: 0.5, // 完美覆盖中间 2 列
                      heightFactor: 0.5, // 完美覆盖中间 2 行
                      child: _buildCenterInfo(), // 现在它有 4 倍的空间了！
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showCommentary) _buildCommentaryPanel(),
        ],
      ),
    );
  }

  // ==========================================
  // 2. 极致清爽的积木拼装
  // ==========================================
  Widget _buildPalaceCell(int palaceIdx) {
    final p = widget.chart.palaces[palaceIdx];

    return PalaceCell(
      name: p.name,
      stem: p.earthlyBranch.isNotEmpty ? p.earthlyBranch[0] : '',
      branch: p.earthlyBranch.length > 1 ? p.earthlyBranch[1] : '',
      isBodyPalace: p.isBodyPalace,
      daXian: _showDynamic ? p.daXianRange : '',
      dynamicMarkers: _showDynamic ? p.dynamicMarkers : const [],
      majorStars: p.majorStars,
      minorStars: p.minorStars,
      miscStars: _showExtended ? p.extendedStars : const [],
      // 🆕 新增：由独立的神煞开关控制四大系列的透传
      lifeTwelve: _showTwelveGods ? p.lifeTwelve : '',
      doctorTwelve: _showTwelveGods ? p.doctorTwelve : '',
      taiSuiTwelve: _showTwelveGods ? p.taiSuiTwelve : '',
      generalTwelve: _showTwelveGods ? p.generalTwelve : '',
    );
  }

  // ==========================================
  // 3. UI 控件区 (开关与中宫展示)
  // ==========================================
  Widget _buildLayerToggles() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      // 🌟 垂直内边距降到 2，水平 8，极致压缩高度空间
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // 丝滑的阻尼回弹
        child: Row(
          children: [
            _buildChipItem("本命", true, null),
            _buildChipItem(
              "杂曜",
              _showExtended,
              (val) => setState(() => _showExtended = val),
            ),
            _buildChipItem(
              "神煞",
              _showTwelveGods,
              (val) => setState(() => _showTwelveGods = val),
            ),
            _buildChipItem(
              "大运",
              _showDynamic,
              (val) => setState(() => _showDynamic = val),
            ),
            _buildChipItem(
              "AI断语",
              _showCommentary,
              (val) => setState(() => _showCommentary = val),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助方法：进一步紧凑化 Chip
  Widget _buildChipItem(
    String label,
    bool isSelected,
    ValueChanged<bool>? onChanged,
  ) {
    final bool isBase = onChanged == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // 代替 SizedBox
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 11, // 略微收紧字号
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : Colors.black54, // 🌟 非选中色改为浅黑，弱化视觉
        ),
        selected: isSelected,
        onSelected: isBase ? (_) {} : onChanged,
        showCheckmark: false,
        selectedColor: isBase ? Colors.grey.shade400 : Colors.red.shade400,
        backgroundColor: Colors.grey.shade50, // 🌟 背景色调浅，更精致
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 🌟 圆角稍微收紧，贴合宫格的方形感
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
        padding: EdgeInsets.zero,
        materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // 🌟 进一步缩小点击区域默认占位，拯救垂直空间
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: -2,
        ), // 负向 padding 压缩高度
      ),
    );
  }

  // ==========================================
  // UI 纯视觉层辅助方法
  // ==========================================
  String _toChineseNumber(int num) {
    const List<String> digits = [
      '零',
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
    ];
    if (num <= 10) return digits[num];
    if (num < 20) return '十${num % 10 == 0 ? '' : digits[num % 10]}';
    if (num < 30) return '二十${num % 10 == 0 ? '' : digits[num % 10]}';
    if (num < 40) return '三十${num % 10 == 0 ? '' : digits[num % 10]}';
    return num.toString();
  }

  String _getBranchChar(int index) => const [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ][index % 12];

  Widget _buildCenterInfo() {
    const TextStyle uniformStyle = TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 19, 14, 12),
      height: 1.4, // 🌟 中宫行高设定为 1.4，呼吸感与空间利用的最佳平衡
      fontFamily: 'NotoSansSC',
    );

    final String dayStr = _toChineseNumber(widget.chart.lunarDay);
    final String monthStr = _toChineseNumber(widget.chart.lunarMonth);
    final String timeStr = _getBranchChar(widget.chart.timeIndex);

    final String lunarTimeText =
        "农历  ${widget.chart.yearGanZhi}年$monthStr月$dayStr日$timeStr时";

    return Center(
      // 🌟 核心修复：FittedBox 确保在任何屏幕下都不会报 Overflow
      child: FittedBox(
        fit: BoxFit.scaleDown, // 仅在溢出时缩小
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("紫微命盘", style: uniformStyle),
              Text(lunarTimeText, style: uniformStyle),
              Text(
                "${widget.chart.genderTag}  ${widget.chart.fiveElements}",
                style: uniformStyle,
              ),
              Text("命主 ${widget.chart.lifeLord}", style: uniformStyle),
              Text("身主 ${widget.chart.bodyLord}", style: uniformStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentaryPanel() {
    final lifePalace = widget.chart.palaces.firstWhere(
      (p) => p.name.contains('命宫'),
      orElse: () => widget.chart.palaces[0],
    );
    final commentaries = DivinationCalculators.getCommentariesForPalace(
      lifePalace,
    );

    if (commentaries.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 150),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "【本命核心断语】",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            ...commentaries.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  "• $text",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.brown,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
