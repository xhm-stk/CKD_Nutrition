// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'log_id')
  String get logId => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_id')
  String get foodId => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_name')
  String get foodName => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_g')
  double get quantityG => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_g')
  double get proteinG => throw _privateConstructorUsedError;
  @JsonKey(name: 'potassium_mg')
  double get potassiumMg => throw _privateConstructorUsedError;
  @JsonKey(name: 'sodium_mg')
  double get sodiumMg => throw _privateConstructorUsedError;
  @JsonKey(name: 'sugar_g')
  double get sugarG => throw _privateConstructorUsedError;
  @JsonKey(name: 'carb_g')
  double get carbG => throw _privateConstructorUsedError;
  @JsonKey(name: 'water_ml')
  double get waterMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'eaten_at')
  DateTime get eatenAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'log_id') String logId,
      @JsonKey(name: 'food_id') String foodId,
      @JsonKey(name: 'food_name') String foodName,
      @JsonKey(name: 'quantity_g') double quantityG,
      @JsonKey(name: 'meal_type') String mealType,
      @JsonKey(name: 'protein_g') double proteinG,
      @JsonKey(name: 'potassium_mg') double potassiumMg,
      @JsonKey(name: 'sodium_mg') double sodiumMg,
      @JsonKey(name: 'sugar_g') double sugarG,
      @JsonKey(name: 'carb_g') double carbG,
      @JsonKey(name: 'water_ml') double waterMl,
      @JsonKey(name: 'eaten_at') DateTime eatenAt});
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? logId = null,
    Object? foodId = null,
    Object? foodName = null,
    Object? quantityG = null,
    Object? mealType = null,
    Object? proteinG = null,
    Object? potassiumMg = null,
    Object? sodiumMg = null,
    Object? sugarG = null,
    Object? carbG = null,
    Object? waterMl = null,
    Object? eatenAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      logId: null == logId
          ? _value.logId
          : logId // ignore: cast_nullable_to_non_nullable
              as String,
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      quantityG: null == quantityG
          ? _value.quantityG
          : quantityG // ignore: cast_nullable_to_non_nullable
              as double,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      potassiumMg: null == potassiumMg
          ? _value.potassiumMg
          : potassiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      sodiumMg: null == sodiumMg
          ? _value.sodiumMg
          : sodiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      sugarG: null == sugarG
          ? _value.sugarG
          : sugarG // ignore: cast_nullable_to_non_nullable
              as double,
      carbG: null == carbG
          ? _value.carbG
          : carbG // ignore: cast_nullable_to_non_nullable
              as double,
      waterMl: null == waterMl
          ? _value.waterMl
          : waterMl // ignore: cast_nullable_to_non_nullable
              as double,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'log_id') String logId,
      @JsonKey(name: 'food_id') String foodId,
      @JsonKey(name: 'food_name') String foodName,
      @JsonKey(name: 'quantity_g') double quantityG,
      @JsonKey(name: 'meal_type') String mealType,
      @JsonKey(name: 'protein_g') double proteinG,
      @JsonKey(name: 'potassium_mg') double potassiumMg,
      @JsonKey(name: 'sodium_mg') double sodiumMg,
      @JsonKey(name: 'sugar_g') double sugarG,
      @JsonKey(name: 'carb_g') double carbG,
      @JsonKey(name: 'water_ml') double waterMl,
      @JsonKey(name: 'eaten_at') DateTime eatenAt});
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? logId = null,
    Object? foodId = null,
    Object? foodName = null,
    Object? quantityG = null,
    Object? mealType = null,
    Object? proteinG = null,
    Object? potassiumMg = null,
    Object? sodiumMg = null,
    Object? sugarG = null,
    Object? carbG = null,
    Object? waterMl = null,
    Object? eatenAt = null,
  }) {
    return _then(_$MealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      logId: null == logId
          ? _value.logId
          : logId // ignore: cast_nullable_to_non_nullable
              as String,
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      quantityG: null == quantityG
          ? _value.quantityG
          : quantityG // ignore: cast_nullable_to_non_nullable
              as double,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      potassiumMg: null == potassiumMg
          ? _value.potassiumMg
          : potassiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      sodiumMg: null == sodiumMg
          ? _value.sodiumMg
          : sodiumMg // ignore: cast_nullable_to_non_nullable
              as double,
      sugarG: null == sugarG
          ? _value.sugarG
          : sugarG // ignore: cast_nullable_to_non_nullable
              as double,
      carbG: null == carbG
          ? _value.carbG
          : carbG // ignore: cast_nullable_to_non_nullable
              as double,
      waterMl: null == waterMl
          ? _value.waterMl
          : waterMl // ignore: cast_nullable_to_non_nullable
              as double,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealImpl implements _Meal {
  const _$MealImpl(
      {required this.id,
      @JsonKey(name: 'log_id') required this.logId,
      @JsonKey(name: 'food_id') required this.foodId,
      @JsonKey(name: 'food_name') required this.foodName,
      @JsonKey(name: 'quantity_g') required this.quantityG,
      @JsonKey(name: 'meal_type') required this.mealType,
      @JsonKey(name: 'protein_g') required this.proteinG,
      @JsonKey(name: 'potassium_mg') required this.potassiumMg,
      @JsonKey(name: 'sodium_mg') required this.sodiumMg,
      @JsonKey(name: 'sugar_g') required this.sugarG,
      @JsonKey(name: 'carb_g') required this.carbG,
      @JsonKey(name: 'water_ml') required this.waterMl,
      @JsonKey(name: 'eaten_at') required this.eatenAt});

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'log_id')
  final String logId;
  @override
  @JsonKey(name: 'food_id')
  final String foodId;
  @override
  @JsonKey(name: 'food_name')
  final String foodName;
  @override
  @JsonKey(name: 'quantity_g')
  final double quantityG;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  @override
  @JsonKey(name: 'protein_g')
  final double proteinG;
  @override
  @JsonKey(name: 'potassium_mg')
  final double potassiumMg;
  @override
  @JsonKey(name: 'sodium_mg')
  final double sodiumMg;
  @override
  @JsonKey(name: 'sugar_g')
  final double sugarG;
  @override
  @JsonKey(name: 'carb_g')
  final double carbG;
  @override
  @JsonKey(name: 'water_ml')
  final double waterMl;
  @override
  @JsonKey(name: 'eaten_at')
  final DateTime eatenAt;

  @override
  String toString() {
    return 'Meal(id: $id, logId: $logId, foodId: $foodId, foodName: $foodName, quantityG: $quantityG, mealType: $mealType, proteinG: $proteinG, potassiumMg: $potassiumMg, sodiumMg: $sodiumMg, sugarG: $sugarG, carbG: $carbG, waterMl: $waterMl, eatenAt: $eatenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.logId, logId) || other.logId == logId) &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.quantityG, quantityG) ||
                other.quantityG == quantityG) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.potassiumMg, potassiumMg) ||
                other.potassiumMg == potassiumMg) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG) &&
            (identical(other.carbG, carbG) || other.carbG == carbG) &&
            (identical(other.waterMl, waterMl) || other.waterMl == waterMl) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      logId,
      foodId,
      foodName,
      quantityG,
      mealType,
      proteinG,
      potassiumMg,
      sodiumMg,
      sugarG,
      carbG,
      waterMl,
      eatenAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {required final String id,
      @JsonKey(name: 'log_id') required final String logId,
      @JsonKey(name: 'food_id') required final String foodId,
      @JsonKey(name: 'food_name') required final String foodName,
      @JsonKey(name: 'quantity_g') required final double quantityG,
      @JsonKey(name: 'meal_type') required final String mealType,
      @JsonKey(name: 'protein_g') required final double proteinG,
      @JsonKey(name: 'potassium_mg') required final double potassiumMg,
      @JsonKey(name: 'sodium_mg') required final double sodiumMg,
      @JsonKey(name: 'sugar_g') required final double sugarG,
      @JsonKey(name: 'carb_g') required final double carbG,
      @JsonKey(name: 'water_ml') required final double waterMl,
      @JsonKey(name: 'eaten_at') required final DateTime eatenAt}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'log_id')
  String get logId;
  @override
  @JsonKey(name: 'food_id')
  String get foodId;
  @override
  @JsonKey(name: 'food_name')
  String get foodName;
  @override
  @JsonKey(name: 'quantity_g')
  double get quantityG;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType;
  @override
  @JsonKey(name: 'protein_g')
  double get proteinG;
  @override
  @JsonKey(name: 'potassium_mg')
  double get potassiumMg;
  @override
  @JsonKey(name: 'sodium_mg')
  double get sodiumMg;
  @override
  @JsonKey(name: 'sugar_g')
  double get sugarG;
  @override
  @JsonKey(name: 'carb_g')
  double get carbG;
  @override
  @JsonKey(name: 'water_ml')
  double get waterMl;
  @override
  @JsonKey(name: 'eaten_at')
  DateTime get eatenAt;
  @override
  @JsonKey(ignore: true)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
