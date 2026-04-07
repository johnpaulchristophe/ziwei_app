import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../widgets/palace_cell.dart';
import '../utils/export_helper.dart';

class SharePreviewPage extends StatefulWidget {
  final ChartResult chart;
  final BirthInput birthInput;
  // 🌟 接收所有可选图层的状态
  final bool showExtended;
  final bool showTwelveGods;
  final bool showDynamic; // 🌟 新增：接收动态层状态

  const SharePreviewPage({
    super.key,
    required this.chart,
    required this.birthInput,
    required this.showExtended,
    required this.showTwelveGods,
    required this.showDynamic,
  });

  @override
  State<SharePreviewPage> createState() => _SharePreviewPageState();
}

class _SharePreviewPageState extends State<SharePreviewPage> {
  // 🌟 截取画布的唯一凭证
  final GlobalKey _boundaryKey = GlobalKey();

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
      backgroundColor: Colors.grey.shade900, // 预览页深色背景，凸显中间的白纸画布
      appBar: AppBar(
        title: const Text('生成命盘图', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // 底部悬浮一个大大的分享按钮
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // 触发 ExportHelper 提取图片并分享
              ExportHelper.captureAndShare(_boundaryKey, context);
            },
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text(
              '保存 / 分享高清图',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: RepaintBoundary(
            key: _boundaryKey, // 🌟 绑定 Key，只截取这里的画面
            child: FittedBox(
              fit: BoxFit.contain, // 缩放以适应屏幕，但真实尺寸不受屏幕限制
              // 🌟 锁死画布绝对分辨率（例如：750 宽，1050 高），保证导出图片永远方正清晰
              child: Container(
                width: 750,
                height: 1050,
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // --- 1. 核心盘面区 ---
                    Expanded(
                      child: Stack(
                        children: [
                          GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // 导出图不需要滚动
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
                              if (palaceIdx == null) return const SizedBox();
                              return _buildStaticPalaceCell(palaceIdx);
                            },
                          ),
                          // 中宫独立图层
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: _buildCenterInfo(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- 2. 底部水印区 ---
                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '排盘规则: 中州派 | 标准时间',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '由 紫微斗数App 生成',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建静态宫格（强制开启基础、杂曜、神煞；强制关闭动态标记）
  Widget _buildStaticPalaceCell(int palaceIdx) {
    final p = widget.chart.palaces[palaceIdx];
    return PalaceCell(
      name: p.name,
      stem: p.earthlyBranch.isNotEmpty ? p.earthlyBranch[0] : '',
      branch: p.earthlyBranch.length > 1 ? p.earthlyBranch[1] : '',
      isBodyPalace: p.isBodyPalace,
      // 👇 根据传入的状态决定是否渲染大限和流年标签
      daXian: widget.showDynamic ? p.daXianRange : '',
      dynamicMarkers: widget.showDynamic ? p.dynamicMarkers : const [],
      majorStars: p.majorStars,
      minorStars: p.minorStars,
      miscStars: widget.showExtended ? p.extendedStars : const [],
      // 🌟 根据传入状态，动态决定是否渲染神煞
      lifeTwelve: widget.showTwelveGods ? p.lifeTwelve : '',
      doctorTwelve: widget.showTwelveGods ? p.doctorTwelve : '',
      taiSuiTwelve: widget.showTwelveGods ? p.taiSuiTwelve : '',
      generalTwelve: widget.showTwelveGods ? p.generalTwelve : '',
    );
  }

  // 内部精简版中宫
  Widget _buildCenterInfo() {
    const TextStyle uniformStyle = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
      height: 1.5,
      fontFamily: 'NotoSansSC',
    );

    // 格式化输出
    final String lunarTimeText =
        "农历 ${widget.chart.yearGanZhi}年 ${_toChineseNumber(widget.chart.lunarMonth)}月 ${_toChineseNumber(widget.chart.lunarDay)}日 ${_getBranchChar(widget.chart.timeIndex)}时";

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "紫微命盘",
              style: uniformStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }

  // 辅助转化方法
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
}
