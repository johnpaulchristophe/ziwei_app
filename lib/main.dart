import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/input_page.dart';

void main() {
  // 注意：这里必须包一层 ProviderScope，否则信号塔不工作
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '紫微斗数',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // 👇 关键：指定全局字体为刚才注册的名字
        fontFamily: 'NotoSansSC',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InputPage(),
    );
  }
}
