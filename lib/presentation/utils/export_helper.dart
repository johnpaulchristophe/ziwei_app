import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class ExportHelper {
  /// 捕获指定的 RepaintBoundary 并触发跨端分享/下载
  /// [boundaryKey] 是包裹着纯净版命盘的 GlobalKey
  static Future<void> captureAndShare(
    GlobalKey boundaryKey,
    BuildContext context,
  ) async {
    try {
      // 1. 寻找当前绑定在 GlobalKey 上的渲染边界
      final boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint("未找到渲染边界");
        return;
      }

      // 2. 将组件转为高清图片 (pixelRatio: 3.0 保证截图在 Retina 屏幕上极其清晰)
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        debugPrint("图片数据转换失败");
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 3. 构建跨平台文件载体 XFile
      // 这里的 fromData 是神仙方法：移动端会在内存中转储，Web 端会自动触发浏览器下载
      final fileName =
          'ziwei_chart_${DateTime.now().millisecondsSinceEpoch}.png';
      final xFile = XFile.fromData(
        pngBytes,
        mimeType: 'image/png',
        name: fileName,
      );

      // 4. 获取触发位置（用于防止 iPad 等大屏设备上拉起分享菜单时找不到锚点而闪退）
      final box = context.findRenderObject() as RenderBox?;
      final rect = box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : null;

      // 5. 呼唤原生分享/下载面板
      await Share.shareXFiles(
        [xFile],
        text: '与你分享一张紫微命盘', // 分享文字（如果用户选微信/邮件，这段字会自动填入）
        sharePositionOrigin: rect,
      );
    } catch (e) {
      debugPrint('分享导出失败: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('导出图片失败，请稍后重试')));
      }
    }
  }
}
