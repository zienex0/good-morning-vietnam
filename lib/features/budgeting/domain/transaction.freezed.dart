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
  double get paidAmount => throw _privateConstructorUsedError;
  String get paidCurrency => throw _privateConstructorUsedError;
  double get accountAmount => throw _privateConstructorUsedError;
  String get accountCurrency => throw _privateConstructorUsedError;
  double? get destAmount => throw _privateConstructorUsedError;
  String? get destCurrency => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  Amortization? get amortization => throw _privateConstructorUsedError;
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
    double paidAmount,
    String paidCurrency,
    double accountAmount,
    String accountCurrency,
    double? destAmount,
    String? destCurrency,
    String? note,
    Amortization? amortization,
    DateTime createdAt,
  });

  $AmortizationCopyWith<$Res>? get amortization;
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
    Object? paidAmount = null,
    Object? paidCurrency = null,
    Object? accountAmount = null,
    Object? accountCurrency = null,
    Object? destAmount = freezed,
    Object? destCurrency = freezed,
    Object? note = freezed,
    Object? amortization = freezed,
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
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidCurrency: null == paidCurrency
                ? _value.paidCurrency
                : paidCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            accountAmount: null == accountAmount
                ? _value.accountAmount
                : accountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            accountCurrency: null == accountCurrency
                ? _value.accountCurrency
                : accountCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            destAmount: freezed == destAmount
                ? _value.destAmount
                : destAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            destCurrency: freezed == destCurrency
                ? _value.destCurrency
                : destCurrency // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            amortization: freezed == amortization
                ? _value.amortization
                : amortization // ignore: cast_nullable_to_non_nullable
                      as Amortization?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AmortizationCopyWith<$Res>? get amortization {
    if (_value.amortization == null) {
      return null;
    }

    return $AmortizationCopyWith<$Res>(_value.amortization!, (value) {
      return _then(_value.copyWith(amortization: value) as $Val);
    });
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
    double paidAmount,
    String paidCurrency,
    double accountAmount,
    String accountCurrency,
    double? destAmount,
    String? destCurrency,
    String? note,
    Amortization? amortization,
    DateTime createdAt,
  });

  @override
  $AmortizationCopyWith<$Res>? get amortization;
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
    Object? paidAmount = null,
    Object? paidCurrency = null,
    Object? accountAmount = null,
    Object? accountCurrency = null,
    Object? destAmount = freezed,
    Object? destCurrency = freezed,
    Object? note = freezed,
    Object? amortization = freezed,
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
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidCurrency: null == paidCurrency
            ? _value.paidCurrency
            : paidCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        accountAmount: null == accountAmount
            ? _value.accountAmount
            : accountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        accountCurrency: null == accountCurrency
            ? _value.accountCurrency
            : accountCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        destAmount: freezed == destAmount
            ? _value.destAmount
            : destAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        destCurrency: freezed == destCurrency
            ? _value.destCurrency
            : destCurrency // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        amortization: freezed == amortization
            ? _value.amortization
            : amortization // ignore: cast_nullable_to_non_nullable
                  as Amortization?,
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
    required this.paidAmount,
    required this.paidCurrency,
    required this.accountAmount,
    required this.accountCurrency,
    this.destAmount,
    this.destCurrency,
    this.note,
    this.amortization,
    required this.createdAt,
  }) : assert(paidAmount > 0, 'paidAmount must be positive'),
       assert(accountAmount > 0, 'accountAmount must be positive'),
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
       assert(
         (type == TransactionType.transfer) ==
             (destAmount != null && destCurrency != null),
         'dest amount is required for transfers and forbidden otherwise',
       ),
       assert(
         destAmount == null || destAmount > 0,
         'destAmount must be positive',
       ),
       assert(
         amortization == null || type == TransactionType.expense,
         'only expenses can be amortized',
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
  final double paidAmount;
  @override
  final String paidCurrency;
  @override
  final double accountAmount;
  @override
  final String accountCurrency;
  @override
  final double? destAmount;
  @override
  final String? destCurrency;
  @override
  final String? note;
  @override
  final Amortization? amortization;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Transaction(id: $id, tripId: $tripId, type: $type, occurredAt: $occurredAt, sourceAccountId: $sourceAccountId, destAccountId: $destAccountId, categoryId: $categoryId, paidAmount: $paidAmount, paidCurrency: $paidCurrency, accountAmount: $accountAmount, accountCurrency: $accountCurrency, destAmount: $destAmount, destCurrency: $destCurrency, note: $note, amortization: $amortization, createdAt: $createdAt)';
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
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paidCurrency, paidCurrency) ||
                other.paidCurrency == paidCurrency) &&
            (identical(other.accountAmount, accountAmount) ||
                other.accountAmount == accountAmount) &&
            (identical(other.accountCurrency, accountCurrency) ||
                other.accountCurrency == accountCurrency) &&
            (identical(other.destAmount, destAmount) ||
                other.destAmount == destAmount) &&
            (identical(other.destCurrency, destCurrency) ||
                other.destCurrency == destCurrency) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.amortization, amortization) ||
                other.amortization == amortization) &&
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
    paidAmount,
    paidCurrency,
    accountAmount,
    accountCurrency,
    destAmount,
    destCurrency,
    note,
    amortization,
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
    required final double paidAmount,
    required final String paidCurrency,
    required final double accountAmount,
    required final String accountCurrency,
    final double? destAmount,
    final String? destCurrency,
    final String? note,
    final Amortization? amortization,
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
  double get paidAmount;
  @override
  String get paidCurrency;
  @override
  double get accountAmount;
  @override
  String get accountCurrency;
  @override
  double? get destAmount;
  @override
  String? get destCurrency;
  @override
  String? get note;
  @override
  Amortization? get amortization;
  @override
  DateTime get createdAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
