// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyLog _$DailyLogFromJson(Map<String, dynamic> json) {
  return _DailyLog.fromJson(json);
}

/// @nodoc
mixin _$DailyLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'log_date')
  String get logDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_protein_g')
  double get totalProteinG => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_potassium_mg')
  double get totalPotassiumMg => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sodium_mg')
  double get totalSodiumMg => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sugar_g')
  double get totalSugarG => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_carb_g')
  double get totalCarbG => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_water_ml')
  double get totalWaterMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_phosphorus_mg')
  double get totalPhosphorusMg =>
      throw _privateConstructorUsedError; // Custom Limits
  double? get customProtein => throw _privateConstructorUsedError;
  double? get customPotassium => throw _privateConstructorUsedError;
  double? get customSodium => throw _privateConstructorUsedError;
  double? get customSugar => throw _privateConstructorUsedError;
  double? get customCarb => throw _privateConstructorUsedError;
  double? get customWater => throw _privateConstructorUsedError;
  double? get customPhosphorus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyLogCopyWith<DailyLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLogCopyWith<$Res> {
  factory $DailyLogCopyWith(DailyLog value, $Res Function(DailyLog) then) =
      _$DailyLogCopyWithImpl<$Res, DailyLog>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'log_date') String logDate,
      @JsonKey(name: 'total_protein_g') double totalProteinG,
      @JsonKey(name: 'total_potassium_mg') double totalPotassiumMg,
      @JsonKey(name: 'total_sodium_mg') double totalSodiumMg,
      @JsonKey(name: 'total_sugar_g') double totalSugarG,
      @JsonKey(name: 'total_carb_g') double totalCarbG,
      @JsonKey(name: 'total_water_ml') double totalWaterMl,
      @JsonKey(name: 'total_phosphorus_mg') double totalPhosphorusMg,
      double? customProtein,
      double? customPotassium,
      double? customSodium,
      double? customSugar,
      double? customCarb,
      double? customWater,
      double? customPhosphorus});
}

/// @nodoc
class _$DailyLogCopyWithImpl<$Res, $Val extends DailyLog>
    implements $DailyLogCopyWith<$Res> {
  _$DailyLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? logDate = null,
    Object? totalProteinG = null,
    Object? totalPotassiumMg = null,
    Object? totalSodiumMg = null,
    Object? totalSugarG = null,
    Object? totalCarbG = null,
    Object? totalWaterMl = null,
    Object? totalPhosphorusMg = null,
    Object? customProtein = freezed,
    Object? customPotassium = freezed,
    Object? customSodium = freezed,
    Object? customSugar = freezed,
    Object? customCarb = freezed,
    Object? customWater = freezed,
    Object? customPhosphorus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      logDate: null == logDate
          ? _value.logDate
          : logDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalProteinG: null == totalProteinG
          ? _value.totalProteinG
          : totalProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      totalPotassiumMg: null == totalPotassiumMg
          ? _value.totalPotassiumMg
          : totalPotassiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      totalSodiumMg: null == totalSodiumMg
          ? _value.totalSodiumMg
          : totalSodiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      totalSugarG: null == totalSugarG
          ? _value.totalSugarG
          : totalSugarG // ignore: cast_nullable_to_non_nullable
              as double,
      totalCarbG: null == totalCarbG
          ? _value.totalCarbG
          : totalCarbG // ignore: cast_nullable_to_non_nullable
              as double,
      totalWaterMl: null == totalWaterMl
          ? _value.totalWaterMl
          : totalWaterMl // ignore: cast_nullable_to_non_nullable
              as double,
      totalPhosphorusMg: null == totalPhosphorusMg
          ? _value.totalPhosphorusMg
          : totalPhosphorusMg // ignore: cast_nullable_to_non_nullable
              as double,
      customProtein: freezed == customProtein
          ? _value.customProtein
          : customProtein // ignore: cast_nullable_to_non_nullable
              as double?,
      customPotassium: freezed == customPotassium
          ? _value.customPotassium
          : customPotassium // ignore: cast_nullable_to_non_nullable
              as double?,
      customSodium: freezed == customSodium
          ? _value.customSodium
          : customSodium // ignore: cast_nullable_to_non_nullable
              as double?,
      customSugar: freezed == customSugar
          ? _value.customSugar
          : customSugar // ignore: cast_nullable_to_non_nullable
              as double?,
      customCarb: freezed == customCarb
          ? _value.customCarb
          : customCarb // ignore: cast_nullable_to_non_nullable
              as double?,
      customWater: freezed == customWater
          ? _value.customWater
          : customWater // ignore: cast_nullable_to_non_nullable
              as double?,
      customPhosphorus: freezed == customPhosphorus
          ? _value.customPhosphorus
          : customPhosphorus // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyLogImplCopyWith<$Res>
    implements $DailyLogCopyWith<$Res> {
  factory _$$DailyLogImplCopyWith(
          _$DailyLogImpl value, $Res Function(_$DailyLogImpl) then) =
      __$$DailyLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'log_date') String logDate,
      @JsonKey(name: 'total_protein_g') double totalProteinG,
      @JsonKey(name: 'total_potassium_mg') double totalPotassiumMg,
      @JsonKey(name: 'total_sodium_mg') double totalSodiumMg,
      @JsonKey(name: 'total_sugar_g') double totalSugarG,
      @JsonKey(name: 'total_carb_g') double totalCarbG,
      @JsonKey(name: 'total_water_ml') double totalWaterMl,
      @JsonKey(name: 'total_phosphorus_mg') double totalPhosphorusMg,
      double? customProtein,
      double? customPotassium,
      double? customSodium,
      double? customSugar,
      double? customCarb,
      double? customWater,
      double? customPhosphorus});
}

/// @nodoc
class __$$DailyLogImplCopyWithImpl<$Res>
    extends _$DailyLogCopyWithImpl<$Res, _$DailyLogImpl>
    implements _$$DailyLogImplCopyWith<$Res> {
  __$$DailyLogImplCopyWithImpl(
      _$DailyLogImpl _value, $Res Function(_$DailyLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? logDate = null,
    Object? totalProteinG = null,
    Object? totalPotassiumMg = null,
    Object? totalSodiumMg = null,
    Object? totalSugarG = null,
    Object? totalCarbG = null,
    Object? totalWaterMl = null,
    Object? totalPhosphorusMg = null,
    Object? customProtein = freezed,
    Object? customPotassium = freezed,
    Object? customSodium = freezed,
    Object? customSugar = freezed,
    Object? customCarb = freezed,
    Object? customWater = freezed,
    Object? customPhosphorus = freezed,
  }) {
    return _then(_$DailyLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      logDate: null == logDate
          ? _value.logDate
          : logDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalProteinG: null == totalProteinG
          ? _value.totalProteinG
          : totalProteinG // ignore: cast_nullable_to_non_nullable
              as double,
      totalPotassiumMg: null == totalPotassiumMg
          ? _value.totalPotassiumMg
          : totalPotassiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      totalSodiumMg: null == totalSodiumMg
          ? _value.totalSodiumMg
          : totalSodiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      totalSugarG: null == totalSugarG
          ? _value.totalSugarG
          : totalSugarG // ignore: cast_nullable_to_non_nullable
              as double,
      totalCarbG: null == totalCarbG
          ? _value.totalCarbG
          : totalCarbG // ignore: cast_nullable_to_non_nullable
              as double,
      totalWaterMl: null == totalWaterMl
          ? _value.totalWaterMl
          : totalWaterMl // ignore: cast_nullable_to_non_nullable
              as double,
      totalPhosphorusMg: null == totalPhosphorusMg
          ? _value.totalPhosphorusMg
          : totalPhosphorusMg // ignore: cast_nullable_to_non_nullable
              as double,
      customProtein: freezed == customProtein
          ? _value.customProtein
          : customProtein // ignore: cast_nullable_to_non_nullable
              as double?,
      customPotassium: freezed == customPotassium
          ? _value.customPotassium
          : customPotassium // ignore: cast_nullable_to_non_nullable
              as double?,
      customSodium: freezed == customSodium
          ? _value.customSodium
          : customSodium // ignore: cast_nullable_to_non_nullable
              as double?,
      customSugar: freezed == customSugar
          ? _value.customSugar
          : customSugar // ignore: cast_nullable_to_non_nullable
              as double?,
      customCarb: freezed == customCarb
          ? _value.customCarb
          : customCarb // ignore: cast_nullable_to_non_nullable
              as double?,
      customWater: freezed == customWater
          ? _value.customWater
          : customWater // ignore: cast_nullable_to_non_nullable
              as double?,
      customPhosphorus: freezed == customPhosphorus
          ? _value.customPhosphorus
          : customPhosphorus // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLogImpl extends _DailyLog {
  const _$DailyLogImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'log_date') required this.logDate,
      @JsonKey(name: 'total_protein_g') this.totalProteinG = 0.0,
      @JsonKey(name: 'total_potassium_mg') this.totalPotassiumMg = 0.0,
      @JsonKey(name: 'total_sodium_mg') this.totalSodiumMg = 0.0,
      @JsonKey(name: 'total_sugar_g') this.totalSugarG = 0.0,
      @JsonKey(name: 'total_carb_g') this.totalCarbG = 0.0,
      @JsonKey(name: 'total_water_ml') this.totalWaterMl = 0.0,
      @JsonKey(name: 'total_phosphorus_mg') this.totalPhosphorusMg = 0.0,
      this.customProtein,
      this.customPotassium,
      this.customSodium,
      this.customSugar,
      this.customCarb,
      this.customWater,
      this.customPhosphorus})
      : super._();

  factory _$DailyLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'log_date')
  final String logDate;
  @override
  @JsonKey(name: 'total_protein_g')
  final double totalProteinG;
  @override
  @JsonKey(name: 'total_potassium_mg')
  final double totalPotassiumMg;
  @override
  @JsonKey(name: 'total_sodium_mg')
  final double totalSodiumMg;
  @override
  @JsonKey(name: 'total_sugar_g')
  final double totalSugarG;
  @override
  @JsonKey(name: 'total_carb_g')
  final double totalCarbG;
  @override
  @JsonKey(name: 'total_water_ml')
  final double totalWaterMl;
  @override
  @JsonKey(name: 'total_phosphorus_mg')
  final double totalPhosphorusMg;
// Custom Limits
  @override
  final double? customProtein;
  @override
  final double? customPotassium;
  @override
  final double? customSodium;
  @override
  final double? customSugar;
  @override
  final double? customCarb;
  @override
  final double? customWater;
  @override
  final double? customPhosphorus;

  @override
  String toString() {
    return 'DailyLog(id: $id, userId: $userId, logDate: $logDate, totalProteinG: $totalProteinG, totalPotassiumMg: $totalPotassiumMg, totalSodiumMg: $totalSodiumMg, totalSugarG: $totalSugarG, totalCarbG: $totalCarbG, totalWaterMl: $totalWaterMl, totalPhosphorusMg: $totalPhosphorusMg, customProtein: $customProtein, customPotassium: $customPotassium, customSodium: $customSodium, customSugar: $customSugar, customCarb: $customCarb, customWater: $customWater, customPhosphorus: $customPhosphorus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.logDate, logDate) || other.logDate == logDate) &&
            (identical(other.totalProteinG, totalProteinG) ||
                other.totalProteinG == totalProteinG) &&
            (identical(other.totalPotassiumMg, totalPotassiumMg) ||
                other.totalPotassiumMg == totalPotassiumMg) &&
            (identical(other.totalSodiumMg, totalSodiumMg) ||
                other.totalSodiumMg == totalSodiumMg) &&
            (identical(other.totalSugarG, totalSugarG) ||
                other.totalSugarG == totalSugarG) &&
            (identical(other.totalCarbG, totalCarbG) ||
                other.totalCarbG == totalCarbG) &&
            (identical(other.totalWaterMl, totalWaterMl) ||
                other.totalWaterMl == totalWaterMl) &&
            (identical(other.totalPhosphorusMg, totalPhosphorusMg) ||
                other.totalPhosphorusMg == totalPhosphorusMg) &&
            (identical(other.customProtein, customProtein) ||
                other.customProtein == customProtein) &&
            (identical(other.customPotassium, customPotassium) ||
                other.customPotassium == customPotassium) &&
            (identical(other.customSodium, customSodium) ||
                other.customSodium == customSodium) &&
            (identical(other.customSugar, customSugar) ||
                other.customSugar == customSugar) &&
            (identical(other.customCarb, customCarb) ||
                other.customCarb == customCarb) &&
            (identical(other.customWater, customWater) ||
                other.customWater == customWater) &&
            (identical(other.customPhosphorus, customPhosphorus) ||
                other.customPhosphorus == customPhosphorus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      logDate,
      totalProteinG,
      totalPotassiumMg,
      totalSodiumMg,
      totalSugarG,
      totalCarbG,
      totalWaterMl,
      totalPhosphorusMg,
      customProtein,
      customPotassium,
      customSodium,
      customSugar,
      customCarb,
      customWater,
      customPhosphorus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLogImplCopyWith<_$DailyLogImpl> get copyWith =>
      __$$DailyLogImplCopyWithImpl<_$DailyLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLogImplToJson(
      this,
    );
  }
}

abstract class _DailyLog extends DailyLog {
  const factory _DailyLog(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'log_date') required final String logDate,
      @JsonKey(name: 'total_protein_g') final double totalProteinG,
      @JsonKey(name: 'total_potassium_mg') final double totalPotassiumMg,
      @JsonKey(name: 'total_sodium_mg') final double totalSodiumMg,
      @JsonKey(name: 'total_sugar_g') final double totalSugarG,
      @JsonKey(name: 'total_carb_g') final double totalCarbG,
      @JsonKey(name: 'total_water_ml') final double totalWaterMl,
      @JsonKey(name: 'total_phosphorus_mg') final double totalPhosphorusMg,
      final double? customProtein,
      final double? customPotassium,
      final double? customSodium,
      final double? customSugar,
      final double? customCarb,
      final double? customWater,
      final double? customPhosphorus}) = _$DailyLogImpl;
  const _DailyLog._() : super._();

  factory _DailyLog.fromJson(Map<String, dynamic> json) =
      _$DailyLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'log_date')
  String get logDate;
  @override
  @JsonKey(name: 'total_protein_g')
  double get totalProteinG;
  @override
  @JsonKey(name: 'total_potassium_mg')
  double get totalPotassiumMg;
  @override
  @JsonKey(name: 'total_sodium_mg')
  double get totalSodiumMg;
  @override
  @JsonKey(name: 'total_sugar_g')
  double get totalSugarG;
  @override
  @JsonKey(name: 'total_carb_g')
  double get totalCarbG;
  @override
  @JsonKey(name: 'total_water_ml')
  double get totalWaterMl;
  @override
  @JsonKey(name: 'total_phosphorus_mg')
  double get totalPhosphorusMg;
  @override // Custom Limits
  double? get customProtein;
  @override
  double? get customPotassium;
  @override
  double? get customSodium;
  @override
  double? get customSugar;
  @override
  double? get customCarb;
  @override
  double? get customWater;
  @override
  double? get customPhosphorus;
  @override
  @JsonKey(ignore: true)
  _$$DailyLogImplCopyWith<_$DailyLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
