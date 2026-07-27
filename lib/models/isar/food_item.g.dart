// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodItemCollection on Isar {
  IsarCollection<FoodItem> get foodItems => this.collection();
}

const FoodItemSchema = CollectionSchema(
  name: r'FoodItem',
  id: 8311037358550475404,
  properties: {
    r'carbG': PropertySchema(id: 0, name: r'carbG', type: IsarType.double),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'cookingMethod': PropertySchema(
      id: 2,
      name: r'cookingMethod',
      type: IsarType.string,
    ),
    r'foodId': PropertySchema(id: 3, name: r'foodId', type: IsarType.string),
    r'ingredients': PropertySchema(
      id: 4,
      name: r'ingredients',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 5, name: r'name', type: IsarType.string),
    r'notes': PropertySchema(id: 6, name: r'notes', type: IsarType.string),
    r'phosphorusMg': PropertySchema(
      id: 7,
      name: r'phosphorusMg',
      type: IsarType.double,
    ),
    r'potassiumMg': PropertySchema(
      id: 8,
      name: r'potassiumMg',
      type: IsarType.double,
    ),
    r'proteinG': PropertySchema(
      id: 9,
      name: r'proteinG',
      type: IsarType.double,
    ),
    r'searchKeywords': PropertySchema(
      id: 10,
      name: r'searchKeywords',
      type: IsarType.string,
    ),
    r'servingSize': PropertySchema(
      id: 11,
      name: r'servingSize',
      type: IsarType.string,
    ),
    r'sodiumMg': PropertySchema(
      id: 12,
      name: r'sodiumMg',
      type: IsarType.double,
    ),
    r'source': PropertySchema(id: 13, name: r'source', type: IsarType.string),
    r'sourceUrl': PropertySchema(
      id: 14,
      name: r'sourceUrl',
      type: IsarType.string,
    ),
    r'sugarG': PropertySchema(id: 15, name: r'sugarG', type: IsarType.double),
    r'waterMl': PropertySchema(id: 16, name: r'waterMl', type: IsarType.double),
  },
  estimateSize: _foodItemEstimateSize,
  serialize: _foodItemSerialize,
  deserialize: _foodItemDeserialize,
  deserializeProp: _foodItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'foodId': IndexSchema(
      id: 6823679418906861405,
      name: r'foodId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'foodId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _foodItemGetId,
  getLinks: _foodItemGetLinks,
  attach: _foodItemAttach,
  version: '3.1.0+1',
);

int _foodItemEstimateSize(
  FoodItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.cookingMethod.length * 3;
  bytesCount += 3 + object.foodId.length * 3;
  bytesCount += 3 + object.ingredients.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.searchKeywords.length * 3;
  bytesCount += 3 + object.servingSize.length * 3;
  bytesCount += 3 + object.source.length * 3;
  {
    final value = object.sourceUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _foodItemSerialize(
  FoodItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.carbG);
  writer.writeString(offsets[1], object.category);
  writer.writeString(offsets[2], object.cookingMethod);
  writer.writeString(offsets[3], object.foodId);
  writer.writeString(offsets[4], object.ingredients);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.notes);
  writer.writeDouble(offsets[7], object.phosphorusMg);
  writer.writeDouble(offsets[8], object.potassiumMg);
  writer.writeDouble(offsets[9], object.proteinG);
  writer.writeString(offsets[10], object.searchKeywords);
  writer.writeString(offsets[11], object.servingSize);
  writer.writeDouble(offsets[12], object.sodiumMg);
  writer.writeString(offsets[13], object.source);
  writer.writeString(offsets[14], object.sourceUrl);
  writer.writeDouble(offsets[15], object.sugarG);
  writer.writeDouble(offsets[16], object.waterMl);
}

FoodItem _foodItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodItem();
  object.carbG = reader.readDouble(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.cookingMethod = reader.readString(offsets[2]);
  object.foodId = reader.readString(offsets[3]);
  object.id = id;
  object.ingredients = reader.readString(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.notes = reader.readStringOrNull(offsets[6]);
  object.phosphorusMg = reader.readDouble(offsets[7]);
  object.potassiumMg = reader.readDouble(offsets[8]);
  object.proteinG = reader.readDouble(offsets[9]);
  object.searchKeywords = reader.readString(offsets[10]);
  object.servingSize = reader.readString(offsets[11]);
  object.sodiumMg = reader.readDouble(offsets[12]);
  object.source = reader.readString(offsets[13]);
  object.sourceUrl = reader.readStringOrNull(offsets[14]);
  object.sugarG = reader.readDouble(offsets[15]);
  object.waterMl = reader.readDouble(offsets[16]);
  return object;
}

P _foodItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _foodItemGetId(FoodItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodItemGetLinks(FoodItem object) {
  return [];
}

void _foodItemAttach(IsarCollection<dynamic> col, Id id, FoodItem object) {
  object.id = id;
}

extension FoodItemByIndex on IsarCollection<FoodItem> {
  Future<FoodItem?> getByFoodId(String foodId) {
    return getByIndex(r'foodId', [foodId]);
  }

  FoodItem? getByFoodIdSync(String foodId) {
    return getByIndexSync(r'foodId', [foodId]);
  }

  Future<bool> deleteByFoodId(String foodId) {
    return deleteByIndex(r'foodId', [foodId]);
  }

  bool deleteByFoodIdSync(String foodId) {
    return deleteByIndexSync(r'foodId', [foodId]);
  }

  Future<List<FoodItem?>> getAllByFoodId(List<String> foodIdValues) {
    final values = foodIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'foodId', values);
  }

  List<FoodItem?> getAllByFoodIdSync(List<String> foodIdValues) {
    final values = foodIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'foodId', values);
  }

  Future<int> deleteAllByFoodId(List<String> foodIdValues) {
    final values = foodIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'foodId', values);
  }

  int deleteAllByFoodIdSync(List<String> foodIdValues) {
    final values = foodIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'foodId', values);
  }

  Future<Id> putByFoodId(FoodItem object) {
    return putByIndex(r'foodId', object);
  }

  Id putByFoodIdSync(FoodItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'foodId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFoodId(List<FoodItem> objects) {
    return putAllByIndex(r'foodId', objects);
  }

  List<Id> putAllByFoodIdSync(List<FoodItem> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'foodId', objects, saveLinks: saveLinks);
  }
}

extension FoodItemQueryWhereSort on QueryBuilder<FoodItem, FoodItem, QWhere> {
  QueryBuilder<FoodItem, FoodItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }
}

extension FoodItemQueryWhere on QueryBuilder<FoodItem, FoodItem, QWhereClause> {
  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> foodIdEqualTo(
    String foodId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'foodId', value: [foodId]),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> foodIdNotEqualTo(
    String foodId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'foodId',
                lower: [],
                upper: [foodId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'foodId',
                lower: [foodId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'foodId',
                lower: [foodId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'foodId',
                lower: [],
                upper: [foodId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameNotEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [name],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [],
          upper: [name],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [lowerName],
          includeLower: includeLower,
          upper: [upperName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameStartsWith(
    String NamePrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [NamePrefix],
          upper: ['$NamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: ['']),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            );
      }
    });
  }
}

extension FoodItemQueryFilter
    on QueryBuilder<FoodItem, FoodItem, QFilterCondition> {
  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> carbGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carbG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> carbGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carbG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> carbGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carbG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> carbGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carbG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  cookingMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cookingMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  cookingMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cookingMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> cookingMethodMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cookingMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  cookingMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cookingMethod', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  cookingMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cookingMethod', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'foodId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'foodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'foodId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'foodId', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> foodIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'foodId', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  ingredientsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ingredients',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ingredients',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ingredients',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> ingredientsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ingredients', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  ingredientsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ingredients', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> phosphorusMgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phosphorusMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  phosphorusMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phosphorusMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> phosphorusMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phosphorusMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> phosphorusMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phosphorusMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> potassiumMgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'potassiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  potassiumMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'potassiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> potassiumMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'potassiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> potassiumMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'potassiumMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> proteinGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proteinG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> proteinGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proteinG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> proteinGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proteinG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> proteinGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proteinG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> searchKeywordsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> searchKeywordsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'searchKeywords',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'searchKeywords',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> searchKeywordsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'searchKeywords',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'searchKeywords', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  searchKeywordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'searchKeywords', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  servingSizeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'servingSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'servingSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'servingSize',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> servingSizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'servingSize', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  servingSizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'servingSize', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sodiumMgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sodiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sodiumMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sodiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sodiumMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sodiumMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sodiumMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sodiumMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'source',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceUrl'),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceUrl'),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sourceUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceUrl', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition>
  sourceUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceUrl', value: ''),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sugarGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sugarG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sugarGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sugarG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sugarGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sugarG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> sugarGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sugarG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> waterMlEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'waterMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> waterMlGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'waterMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> waterMlLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'waterMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterFilterCondition> waterMlBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'waterMl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension FoodItemQueryObject
    on QueryBuilder<FoodItem, FoodItem, QFilterCondition> {}

extension FoodItemQueryLinks
    on QueryBuilder<FoodItem, FoodItem, QFilterCondition> {}

extension FoodItemQuerySortBy on QueryBuilder<FoodItem, FoodItem, QSortBy> {
  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCarbG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCarbGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCookingMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookingMethod', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByCookingMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookingMethod', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByFoodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByFoodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByIngredients() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByIngredientsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByPhosphorusMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByPhosphorusMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByPotassiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByPotassiumMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySearchKeywords() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKeywords', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySearchKeywordsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKeywords', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByServingSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByServingSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySodiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySodiumMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySugarG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortBySugarGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterMl', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> sortByWaterMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterMl', Sort.desc);
    });
  }
}

extension FoodItemQuerySortThenBy
    on QueryBuilder<FoodItem, FoodItem, QSortThenBy> {
  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCarbG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCarbGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCookingMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookingMethod', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByCookingMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cookingMethod', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByFoodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByFoodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodId', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByIngredients() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByIngredientsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByPhosphorusMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByPhosphorusMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByPotassiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByPotassiumMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySearchKeywords() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKeywords', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySearchKeywordsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKeywords', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByServingSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByServingSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySodiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumMg', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySodiumMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumMg', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySugarG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarG', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenBySugarGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarG', Sort.desc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterMl', Sort.asc);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QAfterSortBy> thenByWaterMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterMl', Sort.desc);
    });
  }
}

extension FoodItemQueryWhereDistinct
    on QueryBuilder<FoodItem, FoodItem, QDistinct> {
  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByCarbG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbG');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByCookingMethod({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'cookingMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByFoodId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByIngredients({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredients', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByPhosphorusMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phosphorusMg');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByPotassiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'potassiumMg');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinG');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctBySearchKeywords({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'searchKeywords',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByServingSize({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servingSize', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctBySodiumMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sodiumMg');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctBySource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctBySourceUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctBySugarG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugarG');
    });
  }

  QueryBuilder<FoodItem, FoodItem, QDistinct> distinctByWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'waterMl');
    });
  }
}

extension FoodItemQueryProperty
    on QueryBuilder<FoodItem, FoodItem, QQueryProperty> {
  QueryBuilder<FoodItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> carbGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbG');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> cookingMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cookingMethod');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> foodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodId');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> ingredientsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredients');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FoodItem, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> phosphorusMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phosphorusMg');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> potassiumMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'potassiumMg');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> proteinGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinG');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> searchKeywordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchKeywords');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> servingSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servingSize');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> sodiumMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sodiumMg');
    });
  }

  QueryBuilder<FoodItem, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<FoodItem, String?, QQueryOperations> sourceUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceUrl');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> sugarGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugarG');
    });
  }

  QueryBuilder<FoodItem, double, QQueryOperations> waterMlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterMl');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCkdRuleCacheCollection on Isar {
  IsarCollection<CkdRuleCache> get ckdRuleCaches => this.collection();
}

const CkdRuleCacheSchema = CollectionSchema(
  name: r'CkdRuleCache',
  id: -5120958920711814784,
  properties: {
    r'carbLimitG': PropertySchema(
      id: 0,
      name: r'carbLimitG',
      type: IsarType.double,
    ),
    r'phosphorusLimitMg': PropertySchema(
      id: 1,
      name: r'phosphorusLimitMg',
      type: IsarType.double,
    ),
    r'potassiumLimitMg': PropertySchema(
      id: 2,
      name: r'potassiumLimitMg',
      type: IsarType.double,
    ),
    r'proteinLimitG': PropertySchema(
      id: 3,
      name: r'proteinLimitG',
      type: IsarType.double,
    ),
    r'sodiumLimitMg': PropertySchema(
      id: 4,
      name: r'sodiumLimitMg',
      type: IsarType.double,
    ),
    r'stage': PropertySchema(id: 5, name: r'stage', type: IsarType.string),
    r'sugarLimitG': PropertySchema(
      id: 6,
      name: r'sugarLimitG',
      type: IsarType.double,
    ),
    r'syncedAt': PropertySchema(
      id: 7,
      name: r'syncedAt',
      type: IsarType.string,
    ),
    r'waterLimitMl': PropertySchema(
      id: 8,
      name: r'waterLimitMl',
      type: IsarType.double,
    ),
  },
  estimateSize: _ckdRuleCacheEstimateSize,
  serialize: _ckdRuleCacheSerialize,
  deserialize: _ckdRuleCacheDeserialize,
  deserializeProp: _ckdRuleCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'stage': IndexSchema(
      id: 4281597865616208537,
      name: r'stage',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stage',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _ckdRuleCacheGetId,
  getLinks: _ckdRuleCacheGetLinks,
  attach: _ckdRuleCacheAttach,
  version: '3.1.0+1',
);

int _ckdRuleCacheEstimateSize(
  CkdRuleCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.stage.length * 3;
  bytesCount += 3 + object.syncedAt.length * 3;
  return bytesCount;
}

void _ckdRuleCacheSerialize(
  CkdRuleCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.carbLimitG);
  writer.writeDouble(offsets[1], object.phosphorusLimitMg);
  writer.writeDouble(offsets[2], object.potassiumLimitMg);
  writer.writeDouble(offsets[3], object.proteinLimitG);
  writer.writeDouble(offsets[4], object.sodiumLimitMg);
  writer.writeString(offsets[5], object.stage);
  writer.writeDouble(offsets[6], object.sugarLimitG);
  writer.writeString(offsets[7], object.syncedAt);
  writer.writeDouble(offsets[8], object.waterLimitMl);
}

CkdRuleCache _ckdRuleCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CkdRuleCache();
  object.carbLimitG = reader.readDouble(offsets[0]);
  object.id = id;
  object.phosphorusLimitMg = reader.readDouble(offsets[1]);
  object.potassiumLimitMg = reader.readDouble(offsets[2]);
  object.proteinLimitG = reader.readDouble(offsets[3]);
  object.sodiumLimitMg = reader.readDouble(offsets[4]);
  object.stage = reader.readString(offsets[5]);
  object.sugarLimitG = reader.readDouble(offsets[6]);
  object.syncedAt = reader.readString(offsets[7]);
  object.waterLimitMl = reader.readDouble(offsets[8]);
  return object;
}

P _ckdRuleCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ckdRuleCacheGetId(CkdRuleCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ckdRuleCacheGetLinks(CkdRuleCache object) {
  return [];
}

void _ckdRuleCacheAttach(
  IsarCollection<dynamic> col,
  Id id,
  CkdRuleCache object,
) {
  object.id = id;
}

extension CkdRuleCacheByIndex on IsarCollection<CkdRuleCache> {
  Future<CkdRuleCache?> getByStage(String stage) {
    return getByIndex(r'stage', [stage]);
  }

  CkdRuleCache? getByStageSync(String stage) {
    return getByIndexSync(r'stage', [stage]);
  }

  Future<bool> deleteByStage(String stage) {
    return deleteByIndex(r'stage', [stage]);
  }

  bool deleteByStageSync(String stage) {
    return deleteByIndexSync(r'stage', [stage]);
  }

  Future<List<CkdRuleCache?>> getAllByStage(List<String> stageValues) {
    final values = stageValues.map((e) => [e]).toList();
    return getAllByIndex(r'stage', values);
  }

  List<CkdRuleCache?> getAllByStageSync(List<String> stageValues) {
    final values = stageValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'stage', values);
  }

  Future<int> deleteAllByStage(List<String> stageValues) {
    final values = stageValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'stage', values);
  }

  int deleteAllByStageSync(List<String> stageValues) {
    final values = stageValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'stage', values);
  }

  Future<Id> putByStage(CkdRuleCache object) {
    return putByIndex(r'stage', object);
  }

  Id putByStageSync(CkdRuleCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'stage', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStage(List<CkdRuleCache> objects) {
    return putAllByIndex(r'stage', objects);
  }

  List<Id> putAllByStageSync(
    List<CkdRuleCache> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'stage', objects, saveLinks: saveLinks);
  }
}

extension CkdRuleCacheQueryWhereSort
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QWhere> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CkdRuleCacheQueryWhere
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QWhereClause> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> stageEqualTo(
    String stage,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'stage', value: [stage]),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterWhereClause> stageNotEqualTo(
    String stage,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stage',
                lower: [],
                upper: [stage],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stage',
                lower: [stage],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stage',
                lower: [stage],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stage',
                lower: [],
                upper: [stage],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CkdRuleCacheQueryFilter
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QFilterCondition> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  carbLimitGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carbLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  carbLimitGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carbLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  carbLimitGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carbLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  carbLimitGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carbLimitG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  phosphorusLimitMgEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phosphorusLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  phosphorusLimitMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phosphorusLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  phosphorusLimitMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phosphorusLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  phosphorusLimitMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phosphorusLimitMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  potassiumLimitMgEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'potassiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  potassiumLimitMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'potassiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  potassiumLimitMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'potassiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  potassiumLimitMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'potassiumLimitMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  proteinLimitGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proteinLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  proteinLimitGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proteinLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  proteinLimitGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proteinLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  proteinLimitGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proteinLimitG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sodiumLimitMgEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sodiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sodiumLimitMgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sodiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sodiumLimitMgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sodiumLimitMg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sodiumLimitMgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sodiumLimitMg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  stageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  stageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition> stageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  stageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stage', value: ''),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  stageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stage', value: ''),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sugarLimitGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sugarLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sugarLimitGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sugarLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sugarLimitGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sugarLimitG',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  sugarLimitGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sugarLimitG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'syncedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'syncedAt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: ''),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  syncedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'syncedAt', value: ''),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  waterLimitMlEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'waterLimitMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  waterLimitMlGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'waterLimitMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  waterLimitMlLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'waterLimitMl',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterFilterCondition>
  waterLimitMlBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'waterLimitMl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension CkdRuleCacheQueryObject
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QFilterCondition> {}

extension CkdRuleCacheQueryLinks
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QFilterCondition> {}

extension CkdRuleCacheQuerySortBy
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QSortBy> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortByCarbLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByCarbLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByPhosphorusLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByPhosphorusLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByPotassiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByPotassiumLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortByProteinLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByProteinLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortBySodiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortBySodiumLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortBySugarLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortBySugarLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> sortByWaterLimitMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterLimitMl', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  sortByWaterLimitMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterLimitMl', Sort.desc);
    });
  }
}

extension CkdRuleCacheQuerySortThenBy
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QSortThenBy> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByCarbLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByCarbLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByPhosphorusLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByPhosphorusLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorusLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByPotassiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByPotassiumLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassiumLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByProteinLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByProteinLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenBySodiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumLimitMg', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenBySodiumLimitMgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodiumLimitMg', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenBySugarLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarLimitG', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenBySugarLimitGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugarLimitG', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy> thenByWaterLimitMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterLimitMl', Sort.asc);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QAfterSortBy>
  thenByWaterLimitMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterLimitMl', Sort.desc);
    });
  }
}

extension CkdRuleCacheQueryWhereDistinct
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> {
  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> distinctByCarbLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct>
  distinctByPhosphorusLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phosphorusLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct>
  distinctByPotassiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'potassiumLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct>
  distinctByProteinLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct>
  distinctBySodiumLimitMg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sodiumLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> distinctByStage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> distinctBySugarLimitG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugarLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> distinctBySyncedAt({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CkdRuleCache, CkdRuleCache, QDistinct> distinctByWaterLimitMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'waterLimitMl');
    });
  }
}

extension CkdRuleCacheQueryProperty
    on QueryBuilder<CkdRuleCache, CkdRuleCache, QQueryProperty> {
  QueryBuilder<CkdRuleCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations> carbLimitGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations>
  phosphorusLimitMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phosphorusLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations>
  potassiumLimitMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'potassiumLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations> proteinLimitGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations> sodiumLimitMgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sodiumLimitMg');
    });
  }

  QueryBuilder<CkdRuleCache, String, QQueryOperations> stageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stage');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations> sugarLimitGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugarLimitG');
    });
  }

  QueryBuilder<CkdRuleCache, String, QQueryOperations> syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<CkdRuleCache, double, QQueryOperations> waterLimitMlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterLimitMl');
    });
  }
}
