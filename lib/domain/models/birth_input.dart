import 'package:freezed_annotation/freezed_annotation.dart';
import 'models.dart';

// 必须引入 .freezed.dart (处理不可变性)
part 'birth_input.freezed.dart';
// 必须引入 .g.dart (提供 toJson/fromJson 序列化支持)
part 'birth_input.g.dart';

@freezed
class BirthInput with _$BirthInput {
  const factory BirthInput({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute, // 分钟，用来判断晚子时
    required Gender gender, // 性别枚举
    required CalendarType dateType, // 公历还是农历
    @Default(false) bool isLeapMonth, // 默认非闰月
  }) = _BirthInput;

  // 序列化边界：从基础 Map 恢复强类型领域模型。
  // toJson 方法 freezed 会自动混入 (mixin) 提供，无需手动编写。
  // 注意：内部的枚举 (Gender, CalendarType) 会被底层自动转换为 String 落库。
  factory BirthInput.fromJson(Map<String, dynamic> json) =>
      _$BirthInputFromJson(json);
}
