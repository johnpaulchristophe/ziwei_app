import 'package:flutter/material.dart';
import '../../domain/models/models.dart';

/// 纯净版十二宫格组件 (木偶组件)
class PalaceCell extends StatelessWidget {
  final String name; // 宫名
  final String stem; // 天干
  final String branch; // 地支
  final bool isBodyPalace; // 是否身宫
  final String daXian; // 大限区间
  final List<String> dynamicMarkers; // 动态标记
  final List<Star> majorStars; // 主星
  final List<Star> minorStars; // 辅星
  final List<Star> miscStars; // 杂曜

  // 🆕 新增：四大独立神煞数据
  final String lifeTwelve; // 长生十二神
  final String doctorTwelve; // 博士十二神
  final String taiSuiTwelve; // 太岁十二神
  final String generalTwelve; // 将前诸星

  const PalaceCell({
    super.key,
    required this.name,
    required this.stem,
    required this.branch,
    required this.isBodyPalace,
    required this.daXian,
    required this.dynamicMarkers,
    required this.majorStars,
    required this.minorStars,
    required this.miscStars,
    // 🆕 构造函数同步更新
    required this.lifeTwelve,
    required this.doctorTwelve,
    required this.taiSuiTwelve,
    required this.generalTwelve,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellWidth = constraints.maxWidth;
        final double scale = (cellWidth / 85).clamp(0.8, 1.4);

        return Container(
          margin: const EdgeInsets.all(0.5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 0.5),
          ),
          child: Stack(
            children: [
              // 1. 【左上角】博士系列 - 保持
              Positioned(
                top: 2 * scale,
                left: 3 * scale,
                child: Text(
                  doctorTwelve,
                  style: TextStyle(
                    fontSize: 7.5 * scale,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),

              // 2. 【左下角】太岁系列 - 稍微上移 2px (从 26 -> 28)
              Positioned(
                bottom: 28 * scale,
                left: 3 * scale,
                child: Text(
                  taiSuiTwelve,
                  style: TextStyle(
                    fontSize: 7.5 * scale,
                    color: Colors.purple.shade600,
                  ),
                ),
              ),

              // 3. 【右上角】将前系列 - 保持
              Positioned(
                top: 20 * scale,
                right: 3 * scale,
                child: Text(
                  generalTwelve,
                  style: TextStyle(
                    fontSize: 7 * scale,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              // 4. 【右下角】长生系列 - 稍微上移 2px (从 26 -> 28)
              Positioned(
                bottom: 28 * scale,
                right: 3 * scale,
                child: Text(
                  lifeTwelve,
                  style: TextStyle(
                    fontSize: 7.5 * scale,
                    color: Colors.orange.shade900,
                  ),
                ),
              ),

              // 核心微调：星曜安全区
              Positioned(
                top: 4 * scale,
                left: 15 * scale,
                right: 15 * scale,
                bottom: 28 * scale, // 🌟 关键改动：将底部安全边距从 24 提至 28，强行托起杂曜
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 主辅星
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4 * scale,
                      runSpacing: 2 * scale,
                      children: [
                        ...majorStars.map(
                          (s) => _buildVerticalStar(s, scale, isMajor: true),
                        ),
                        ...minorStars.map(
                          (s) => _buildVerticalStar(s, scale, isMajor: false),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // 杂曜区：通过 Padding 进一步手动拉开与下方的距离
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 2 * scale,
                      ), // 🌟 额外增加宫内间距
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 3 * scale,
                        children: miscStars
                            .map(
                              (s) => _buildVerticalStar(s, scale, isMisc: true),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // 动态标签、大限、宫名区保持相对位置...
              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: dynamicMarkers
                      .map((marker) => _buildDynamicMarker(marker, scale))
                      .toList(),
                ),
              ),

              Positioned(
                bottom: 4 * scale,
                left: 4 * scale,
                child: Text(
                  daXian,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 8.5 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (isBodyPalace)
                Positioned(
                  bottom: 56 * scale, // 坐标 1：高度在宫名上方
                  right: 8 * scale, // 坐标 2：向左错开，避开紧贴右壁的"长生"神煞
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3 * scale,
                      vertical: 1.5 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      border: Border.all(
                        color: Colors.pink.shade300,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2 * scale),
                    ),
                    child: Text(
                      "身宫",
                      style: TextStyle(
                        fontSize: 8 * scale, // 稍微加大一点点字号
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),

              Positioned(
                bottom: 2 * scale,
                right: 2 * scale,
                child: _buildPalaceNameArea(scale),
              ),
            ],
          ),
        );
      },
    );
  }

  // 宫名与干支区域保持不变...
  Widget _buildPalaceNameArea(double scale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...name
                .split('')
                .map(
                  (char) => Text(
                    char,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * scale,
                      height: 1.05,
                    ),
                  ),
                ),
          ],
        ),
        SizedBox(width: 3 * scale),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stem,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 9 * scale,
                height: 1.1,
              ),
            ),
            Text(
              branch,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 9 * scale,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 动态标签样式匹配保持不变...
  Widget _buildDynamicMarker(String marker, double scale) {
    Color bgColor = Colors.grey.shade100;
    Color textColor = Colors.grey;
    if (marker == '流年') {
      bgColor = Colors.red.shade100;
      textColor = Colors.red;
    } else if (marker == '斗君') {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (marker == '流月') {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1 * scale),
      padding: EdgeInsets.symmetric(horizontal: 2 * scale, vertical: 1 * scale),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        marker,
        style: TextStyle(
          fontSize: 8 * scale,
          color: textColor,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      ),
    );
  }

  // 竖向星曜渲染组件保持不变...
  Widget _buildVerticalStar(
    Star star,
    double scale, {
    bool isMajor = false,
    bool isMisc = false,
  }) {
    return SizedBox(
      width: (isMajor ? 13.5 : 10.5) * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            star.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (isMajor ? 12 : 9.5) * scale,
              height: 1.05,
              fontWeight: isMajor ? FontWeight.bold : FontWeight.normal,
              color: isMajor
                  ? const Color(0xFFB71C1C)
                  : (isMisc ? Colors.black54 : Colors.black87),
            ),
          ),
          if (star.brightness != null)
            Padding(
              padding: EdgeInsets.only(top: 1 * scale),
              child: Text(
                star.brightness!,
                style: TextStyle(
                  fontSize: 8 * scale,
                  color: _getBrightnessColor(star.brightness!),
                  height: 1.0,
                ),
              ),
            ),
          if (star.modifier != null)
            Container(
              margin: EdgeInsets.only(top: 1.5 * scale),
              padding: EdgeInsets.symmetric(horizontal: 1 * scale),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(1.5),
              ),
              child: Text(
                star.modifier!,
                style: TextStyle(
                  fontSize: 7.5 * scale,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBrightnessColor(String b) {
    if (b == '庙' || b == '旺') return Colors.orange[800]!;
    if (b == '陷') return Colors.blue[800]!;
    return Colors.grey[600]!;
  }
}
