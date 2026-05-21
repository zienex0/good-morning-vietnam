// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;
  String? get sourceAccountId => throw _privateConstructorUsedError;
  String? get destAccountId => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double get amountHome => throw _privateConstructorUsedError;
  double get fxRate => throw _privateConstructorUsedError;
  double? get enteredAmount => throw _privateConstructorUsedError;
  String? get enteredCurrency => throw _privateConstructorUsedError;
  double? get enteredFxRate => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String tripId,
    TransactionType type,
    DateTime occurredAt,
    String? sourceAccountId,
    String? destAccountId,
    String? categoryId,
    double amount,
    String currency,
    double amountHome,
    double fxRate,
    double? enteredAmount,
    String? enteredCurrency,
    double? enteredFxRate,
    String? note,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? type = null,
    Object? occurredAt = null,
    Object? sourceAccountId = freezed,
    Object? destAccountId = freezed,
    Object? categoryId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? amountHome = null,
    Object? fxRate = null,
    Object? enteredAmount = freezed,
    Object? enteredCurrency = freezed,
    Object? enteredFxRate = freezed,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: null == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            occurredAt: null == occurredAt
                ? _value.occurredAt
                : occurredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sourceAccountId: freezed == sourceAccountId
                ? _value.sourceAccountId
                : sourceAccountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            destAccountId: freezed == destAccountId
                ? _value.destAccountId
                : destAccountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            amountHome: null == amountHome
                ? _value.amountHome
                : amountHome // ignore: cast_nullable_to_non_nullable
                      as double,
            fxRate: null == fxRate
                ? _value.fxRate
                : fxRate // ignore: cast_nullable_to_non_nullable
                      as double,
            enteredAmount: freezed == enteredAmount
                ? _value.enteredAmount
                : enteredAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            enteredCurrency: freezed == enteredCurrency
                ? _value.enteredCurrency
                : enteredCurrency // ignore: cast_nullable_to_non_nullable
                      as String?,
            enteredFxRate: freezed == enteredFxRate
                ? _value.enteredFxRate
                : enteredFxRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tripId,
    TransactionType type,
    DateTime occurredAt,
    String? sourceAccountId,
    String? destAccountId,
    String? categoryId,
    double amount,
    String currency,
    double amountHome,
    double fxRate,
    double? enteredAmount,
    String? enteredCurrency,
    double? enteredFxRate,
    String? note,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? type = null,
    Object? occurredAt = null,
    Object? sourceAccountId = freezed,
    Object? destAccountId = freezed,
    Object? categoryId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? amountHome = null,
    Object? fxRate = null,
    Object? enteredAmount = freezed,
    Object? enteredCurrency = freezed,
    Object? enteredFxRate = freezed,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        occurredAt: null == occurredAt
            ? _value.occurredAt
            : occurredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sourceAccountId: freezed == sourceAccountId
            ? _value.sourceAccountId
            : sourceAccountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        destAccountId: freezed == destAccountId
            ? _value.destAccountId
            : destAccountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        amountHome: null == amountHome
            ? _value.amountHome
            : amountHome // ignore: cast_nullable_to_non_nullable
                  as double,
        fxRate: null == fxRate
            ? _value.fxRate
            : fxRate // ignore: cast_nullable_to_non_nullable
                  as double,
        enteredAmount: freezed == enteredAmount
            ? _value.enteredAmount
            : enteredAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        enteredCurrency: freezed == enteredCurrency
            ? _value.enteredCurrency
            : enteredCurrency // ignore: cast_nullable_to_non_nullable
                  as String?,
        enteredFxRate: freezed == enteredFxRate
            ? _value.enteredFxRate
            : enteredFxRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TransactionImpl extends _Transaction {
  _$TransactionImpl({
    required this.id,
    required this.tripId,
    required this.type,
    required this.occurredAt,
    this.sourceAccountId,
    this.destAccountId,
    this.categoryId,
    required this.amount,
    required this.currency,
    required this.amountHome,
    required this.fxRate,
    this.enteredAmount,
    this.enteredCurrency,
    this.enteredFxRate,
    this.note,
    required this.createdAt,
  }) : assert(amount > 0, 'amount must be positive'),
       assert(amountHome > 0, 'amountHome must be positive'),
       assert(fxRate > 0, 'fxRate must be positive'),
       assert(
         (enteredAmount == null &&
                 enteredCurrency == null &&
                 enteredFxRate == null) ||
             (enteredAmount != null &&
                 enteredAmount > 0 &&
                 enteredCurrency != null &&
                 enteredFxRate != null &&
                 enteredFxRate > 0),
         'entered currency details must be complete and positive',
       ),
       assert(
         type != TransactionType.expense ||
             (sourceAccountId != null &&
                 destAccountId == null &&
                 categoryId != null),
         'expense transactions need a source account and category only',
       ),
       assert(
         type != TransactionType.income ||
             (sourceAccountId == null && destAccountId != null),
         'income transactions need a destination account only',
       ),
       assert(
         type != TransactionType.transfer ||
             (sourceAccountId != null &&
                 destAccountId != null &&
                 categoryId == null),
         'transfer transactions need source and destination accounts only',
       ),
       super._();

  @override
  final String id;
  @override
  final String tripId;
  @override
  final TransactionType type;
  @override
  final DateTime occurredAt;
  @override
  final String? sourceAccountId;
  @override
  final String? destAccountId;
  @override
  final String? categoryId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final double amountHome;
  @override
  final double fxRate;
  @override
  final double? enteredAmount;
  @override
  final String? enteredCurrency;
  @override
  final double? enteredFxRate;
  @override
  final String? note;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Transaction(id: $id, tripId: $tripId, type: $type, occurredAt: $occurredAt, sourceAccountId: $sourceAccountId, destAccountId: $destAccountId, categoryId: $categoryId, amount: $amount, currency: $currency, amountHome: $amountHome, fxRate: $fxRate, enteredAmount: $enteredAmount, enteredCurrency: $enteredCurrency, enteredFxRate: $enteredFxRate, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.sourceAccountId, sourceAccountId) ||
                other.sourceAccountId == sourceAccountId) &&
            (identical(other.destAccountId, destAccountId) ||
                other.destAccountId == destAccountId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amountHome, amountHome) ||
                other.amountHome == amountHome) &&
            (identical(other.fxRate, fxRate) || other.fxRate == fxRate) &&
            (identical(other.enteredAmount, enteredAmount) ||
                other.enteredAmount == enteredAmount) &&
            (identical(other.enteredCurrency, enteredCurrency) ||
                other.enteredCurrency == enteredCurrency) &&
            (identical(other.enteredFxRate, enteredFxRate) ||
                other.enteredFxRate == enteredFxRate) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tripId,
    type,
    occurredAt,
    sourceAccountId,
    destAccountId,
    categoryId,
    amount,
    currency,
    amountHome,
    fxRate,
    enteredAmount,
    enteredCurrency,
    enteredFxRate,
    note,
    createdAt,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction extends Transaction {
  factory _Transaction({
    required final String id,
    required final String tripId,
    required final TransactionType type,
    required final DateTime occurredAt,
    final String? sourceAccountId,
    final String? destAccountId,
    final String? categoryId,
    required final double amount,
    required final String currency,
    required final double amountHome,
    required final double fxRate,
    final double? enteredAmount,
    final String? enteredCurrency,
    final double? enteredFxRate,
    final String? note,
    required final DateTime createdAt,
  }) = _$TransactionImpl;
  _Transaction._() : super._();

  @override
  String get id;
  @override
  String get tripId;
  @override
  TransactionType get type;
  @override
  DateTime get occurredAt;
  @override
  String? get sourceAccountId;
  @override
  String? get destAccountId;
  @override
  String? get categoryId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  double get amountHome;
  @override
  double get fxRate;
  @override
  double? get enteredAmount;
  @override
  String? get enteredCurrency;
  @override
  double? get enteredFxRate;
  @override
  String? get note;
  @override
  DateTime get createdAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
