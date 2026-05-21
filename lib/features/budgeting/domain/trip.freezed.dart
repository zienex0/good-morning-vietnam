// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get homeCurrency => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  double? get budgetTotal => throw _privateConstructorUsedError;
  TripStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    String id,
    String name,
    String homeCurrency,
    DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
    TripStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? homeCurrency = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? budgetTotal = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            homeCurrency: null == homeCurrency
                ? _value.homeCurrency
                : homeCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            budgetTotal: freezed == budgetTotal
                ? _value.budgetTotal
                : budgetTotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TripStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String homeCurrency,
    DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
    TripStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? homeCurrency = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? budgetTotal = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        homeCurrency: null == homeCurrency
            ? _value.homeCurrency
            : homeCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        budgetTotal: freezed == budgetTotal
            ? _value.budgetTotal
            : budgetTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TripStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TripImpl extends _Trip {
  _$TripImpl({
    required this.id,
    required this.name,
    required this.homeCurrency,
    required this.startDate,
    this.endDate,
    this.budgetTotal,
    required this.status,
    required this.createdAt,
  }) : assert(
         endDate == null || !endDate.isBefore(startDate),
         'endDate cannot be before startDate',
       ),
       assert(
         budgetTotal == null || budgetTotal >= 0,
         'budgetTotal cannot be negative',
       ),
       super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String homeCurrency;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final double? budgetTotal;
  @override
  final TripStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Trip(id: $id, name: $name, homeCurrency: $homeCurrency, startDate: $startDate, endDate: $endDate, budgetTotal: $budgetTotal, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.homeCurrency, homeCurrency) ||
                other.homeCurrency == homeCurrency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.budgetTotal, budgetTotal) ||
                other.budgetTotal == budgetTotal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    homeCurrency,
    startDate,
    endDate,
    budgetTotal,
    status,
    createdAt,
  );

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);
}

abstract class _Trip extends Trip {
  factory _Trip({
    required final String id,
    required final String name,
    required final String homeCurrency,
    required final DateTime startDate,
    final DateTime? endDate,
    final double? budgetTotal,
    required final TripStatus status,
    required final DateTime createdAt,
  }) = _$TripImpl;
  _Trip._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get homeCurrency;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  double? get budgetTotal;
  @override
  TripStatus get status;
  @override
  DateTime get createdAt;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
