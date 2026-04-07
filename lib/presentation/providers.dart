import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/ziwei_engine.dart';
import '../infrastructure/ziwei_algorithm.dart';

// 全局信号塔：谁要用引擎，就来找 engineProvider
final engineProvider = Provider<ZiweiEngine>((ref) => ZiweiAlgorithm());
