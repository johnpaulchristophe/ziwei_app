// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BirthInput _$BirthInputFromJson(Map<String, dynamic> json) {
  return _BirthInput.fromJson(json);
}

/// @nodoc
mixin _$BirthInput {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError; // 分钟，用来判断晚子时
  Gender get gender => throw _privateConstructorUsedError; // 性别枚举
  CalendarType get dateType => throw _privateConstructorUsedError; // 公历还是农历
  bool get isLeapMonth => throw _privateConstructorUsedError;

  /// Serializes this BirthInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BirthInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthInputCopyWith<BirthInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthInputCopyWith<$Res> {
  factory $BirthInputCopyWith(
    BirthInput value,
    $Res Function(BirthInput) then,
  ) = _$BirthInputCopyWithImpl<$Res, BirthInput>;
  @useResult
  $Res call({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    Gender gender,
    CalendarType dateType,
    bool isLeapMonth,
  });
}

/// @nodoc
class _$BirthInputCopyWithImpl<$Res, $Val extends BirthInput>
    implements $BirthInputCopyWith<$Res> {
  _$BirthInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BirthInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? day = null,
    Object? hour = null,
    Object? minute = null,
    Object? gender = null,
    Object? dateType = null,
    Object? isLeapMonth = null,
  }) {
    return _then(
      _value.copyWith(
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                      as int,
            minute: null == minute
                ? _value.minute
                : minute // ignore: cast_nullable_to_non_nullable
                      as int,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender,
            dateType: null == dateType
                ? _value.dateType
                : dateType // ignore: cast_nullable_to_non_nullable
                      as CalendarType,
            isLeapMonth: null == isLeapMonth
                ? _value.isLeapMonth
                : isLeapMonth // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BirthInputImplCopyWith<$Res>
    implements $BirthInputCopyWith<$Res> {
  factory _$$BirthInputImplCopyWith(
    _$BirthInputImpl value,
    $Res Function(_$BirthInputImpl) then,
  ) = __$$BirthInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    Gender gender,
    CalendarType dateType,
    bool isLeapMonth,
  });
}

/// @nodoc
class __$$BirthInputImplCopyWithImpl<$Res>
    extends _$BirthInputCopyWithImpl<$Res, _$BirthInputImpl>
    implements _$$BirthInputImplCopyWith<$Res> {
  __$$BirthInputImplCopyWithImpl(
    _$BirthInputImpl _value,
    $Res Function(_$BirthInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BirthInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? day = null,
    Object? hour = null,
    Object? minute = null,
    Object? gender = null,
    Object? dateType = null,
    Object? isLeapMonth = null,
  }) {
    return _then(
      _$BirthInputImpl(
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
                  as int,
        minute: null == minute
            ? _value.minute
            : minute // ignore: cast_nullable_to_non_nullable
                  as int,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender,
        dateType: null == dateType
            ? _value.dateType
            : dateType // ignore: cast_nullable_to_non_nullable
                  as CalendarType,
        isLeapMonth: null == isLeapMonth
            ? _value.isLeapMonth
            : isLeapMonth // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BirthInputImpl implements _BirthInput {
  const _$BirthInputImpl({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.gender,
    required this.dateType,
    this.isLeapMonth = false,
  });

  factory _$BirthInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$BirthInputImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  final int day;
  @override
  final int hour;
  @override
  final int minute;
  // 分钟，用来判断晚子时
  @override
  final Gender gender;
  // 性别枚举
  @override
  final CalendarType dateType;
  // 公历还是农历
  @override
  @JsonKey()
  final bool isLeapMonth;

  @override
  String toString() {
    return 'BirthInput(year: $year, month: $month, day: $day, hour: $hour, minute: $minute, gender: $gender, dateType: $dateType, isLeapMonth: $isLeapMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthInputImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.dateType, dateType) ||
                other.dateType == dateType) &&
            (identical(other.isLeapMonth, isLeapMonth) ||
                other.isLeapMonth == isLeapMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    year,
    month,
    day,
    hour,
    minute,
    gender,
    dateType,
    isLeapMonth,
  );

  /// Create a copy of BirthInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthInputImplCopyWith<_$BirthInputImpl> get copyWith =>
      __$$BirthInputImplCopyWithImpl<_$BirthInputImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BirthInputImplToJson(this);
  }
}

abstract class _BirthInput implements BirthInput {
  const factory _BirthInput({
    required final int year,
    required final int month,
    required final int day,
    required final int hour,
    required final int minute,
    required final Gender gender,
    required final CalendarType dateType,
    final bool isLeapMonth,
  }) = _$BirthInputImpl;

  factory _BirthInput.fromJson(Map<String, dynamic> json) =
      _$BirthInputImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  int get day;
  @override
  int get hour;
  @override
  int get minute; // 分钟，用来判断晚子时
  @override
  Gender get gender; // 性别枚举
  @override
  CalendarType get dateType; // 公历还是农历
  @override
  bool get isLeapMonth;

  /// Create a copy of BirthInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthInputImplCopyWith<_$BirthInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
