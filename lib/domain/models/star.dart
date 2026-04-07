// lib/domain/models/star.dart

class Star {
  final String name; // 星曜名称，如 "紫微"
  final String? modifier; // 四化标签，如 "禄"、"权"、"科"、"忌" 或 null
  final String? brightness;

  Star({required this.name, this.modifier, this.brightness});
}
