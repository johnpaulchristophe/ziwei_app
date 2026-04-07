// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birth_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BirthInputImpl _$$BirthInputImplFromJson(Map<String, dynamic> json) =>
    _$BirthInputImpl(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      dateType: $enumDecode(_$CalendarTypeEnumMap, json['dateType']),
      isLeapMonth: json['isLeapMonth'] as bool? ?? false,
    );

Map<String, dynamic> _$$BirthInputImplToJson(_$BirthInputImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dateType': _$CalendarTypeEnumMap[instance.dateType]!,
      'isLeapMonth': instance.isLeapMonth,
    };

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$CalendarTypeEnumMap = {
  CalendarType.solar: 'solar',
  CalendarType.lunar: 'lunar',
};
