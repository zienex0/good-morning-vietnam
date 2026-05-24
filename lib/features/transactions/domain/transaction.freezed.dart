// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 String get id; String get tripId; TransactionType get type; DateTime get occurredAt; String? get sourceAccountId; String? get destAccountId; String? get categoryId; double get paidAmount; CurrencyCode get paidCurrency; double get accountAmount; CurrencyCode get accountCurrency; double? get destAmount; CurrencyCode? get destCurrency; String? get note; Amortization? get amortization; DateTime get createdAt;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.destAccountId, destAccountId) || other.destAccountId == destAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paidCurrency, paidCurrency) || other.paidCurrency == paidCurrency)&&(identical(other.accountAmount, accountAmount) || other.accountAmount == accountAmount)&&(identical(other.accountCurrency, accountCurrency) || other.accountCurrency == accountCurrency)&&(identical(other.destAmount, destAmount) || other.destAmount == destAmount)&&(identical(other.destCurrency, destCurrency) || other.destCurrency == destCurrency)&&(identical(other.note, note) || other.note == note)&&(identical(other.amortization, amortization) || other.amortization == amortization)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tripId,type,occurredAt,sourceAccountId,destAccountId,categoryId,paidAmount,paidCurrency,accountAmount,accountCurrency,destAmount,destCurrency,note,amortization,createdAt);

@override
String toString() {
  return 'Transaction(id: $id, tripId: $tripId, type: $type, occurredAt: $occurredAt, sourceAccountId: $sourceAccountId, destAccountId: $destAccountId, categoryId: $categoryId, paidAmount: $paidAmount, paidCurrency: $paidCurrency, accountAmount: $accountAmount, accountCurrency: $accountCurrency, destAmount: $destAmount, destCurrency: $destCurrency, note: $note, amortization: $amortization, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, String tripId, TransactionType type, DateTime occurredAt, String? sourceAccountId, String? destAccountId, String? categoryId, double paidAmount, CurrencyCode paidCurrency, double accountAmount, CurrencyCode accountCurrency, double? destAmount, CurrencyCode? destCurrency, String? note, Amortization? amortization, DateTime createdAt
});


$AmortizationCopyWith<$Res>? get amortization;

}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = null,Object? type = null,Object? occurredAt = null,Object? sourceAccountId = freezed,Object? destAccountId = freezed,Object? categoryId = freezed,Object? paidAmount = null,Object? paidCurrency = null,Object? accountAmount = null,Object? accountCurrency = null,Object? destAmount = freezed,Object? destCurrency = freezed,Object? note = freezed,Object? amortization = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destAccountId: freezed == destAccountId ? _self.destAccountId : destAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,paidCurrency: null == paidCurrency ? _self.paidCurrency : paidCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode,accountAmount: null == accountAmount ? _self.accountAmount : accountAmount // ignore: cast_nullable_to_non_nullable
as double,accountCurrency: null == accountCurrency ? _self.accountCurrency : accountCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode,destAmount: freezed == destAmount ? _self.destAmount : destAmount // ignore: cast_nullable_to_non_nullable
as double?,destCurrency: freezed == destCurrency ? _self.destCurrency : destCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,amortization: freezed == amortization ? _self.amortization : amortization // ignore: cast_nullable_to_non_nullable
as Amortization?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmortizationCopyWith<$Res>? get amortization {
    if (_self.amortization == null) {
    return null;
  }

  return $AmortizationCopyWith<$Res>(_self.amortization!, (value) {
    return _then(_self.copyWith(amortization: value));
  });
}
}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tripId,  TransactionType type,  DateTime occurredAt,  String? sourceAccountId,  String? destAccountId,  String? categoryId,  double paidAmount,  CurrencyCode paidCurrency,  double accountAmount,  CurrencyCode accountCurrency,  double? destAmount,  CurrencyCode? destCurrency,  String? note,  Amortization? amortization,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.tripId,_that.type,_that.occurredAt,_that.sourceAccountId,_that.destAccountId,_that.categoryId,_that.paidAmount,_that.paidCurrency,_that.accountAmount,_that.accountCurrency,_that.destAmount,_that.destCurrency,_that.note,_that.amortization,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tripId,  TransactionType type,  DateTime occurredAt,  String? sourceAccountId,  String? destAccountId,  String? categoryId,  double paidAmount,  CurrencyCode paidCurrency,  double accountAmount,  CurrencyCode accountCurrency,  double? destAmount,  CurrencyCode? destCurrency,  String? note,  Amortization? amortization,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.tripId,_that.type,_that.occurredAt,_that.sourceAccountId,_that.destAccountId,_that.categoryId,_that.paidAmount,_that.paidCurrency,_that.accountAmount,_that.accountCurrency,_that.destAmount,_that.destCurrency,_that.note,_that.amortization,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tripId,  TransactionType type,  DateTime occurredAt,  String? sourceAccountId,  String? destAccountId,  String? categoryId,  double paidAmount,  CurrencyCode paidCurrency,  double accountAmount,  CurrencyCode accountCurrency,  double? destAmount,  CurrencyCode? destCurrency,  String? note,  Amortization? amortization,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.tripId,_that.type,_that.occurredAt,_that.sourceAccountId,_that.destAccountId,_that.categoryId,_that.paidAmount,_that.paidCurrency,_that.accountAmount,_that.accountCurrency,_that.destAmount,_that.destCurrency,_that.note,_that.amortization,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction extends Transaction {
   _Transaction({required this.id, required this.tripId, required this.type, required this.occurredAt, this.sourceAccountId, this.destAccountId, this.categoryId, required this.paidAmount, required this.paidCurrency, required this.accountAmount, required this.accountCurrency, this.destAmount, this.destCurrency, this.note, this.amortization, required this.createdAt}): assert(paidAmount > 0, 'paidAmount must be positive'),assert(accountAmount > 0, 'accountAmount must be positive'),assert(type != TransactionType.expense || (sourceAccountId != null && destAccountId == null && categoryId != null), 'expense transactions need a source account and category only'),assert(type != TransactionType.income || (sourceAccountId == null && destAccountId != null), 'income transactions need a destination account only'),assert(type != TransactionType.transfer || (sourceAccountId != null && destAccountId != null && categoryId == null), 'transfer transactions need source and destination accounts only'),assert((type == TransactionType.transfer) == (destAmount != null && destCurrency != null), 'dest amount is required for transfers and forbidden otherwise'),assert(destAmount == null || destAmount > 0, 'destAmount must be positive'),assert(amortization == null || type == TransactionType.expense, 'only expenses can be amortized'),super._();
  

@override final  String id;
@override final  String tripId;
@override final  TransactionType type;
@override final  DateTime occurredAt;
@override final  String? sourceAccountId;
@override final  String? destAccountId;
@override final  String? categoryId;
@override final  double paidAmount;
@override final  CurrencyCode paidCurrency;
@override final  double accountAmount;
@override final  CurrencyCode accountCurrency;
@override final  double? destAmount;
@override final  CurrencyCode? destCurrency;
@override final  String? note;
@override final  Amortization? amortization;
@override final  DateTime createdAt;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.destAccountId, destAccountId) || other.destAccountId == destAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paidCurrency, paidCurrency) || other.paidCurrency == paidCurrency)&&(identical(other.accountAmount, accountAmount) || other.accountAmount == accountAmount)&&(identical(other.accountCurrency, accountCurrency) || other.accountCurrency == accountCurrency)&&(identical(other.destAmount, destAmount) || other.destAmount == destAmount)&&(identical(other.destCurrency, destCurrency) || other.destCurrency == destCurrency)&&(identical(other.note, note) || other.note == note)&&(identical(other.amortization, amortization) || other.amortization == amortization)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tripId,type,occurredAt,sourceAccountId,destAccountId,categoryId,paidAmount,paidCurrency,accountAmount,accountCurrency,destAmount,destCurrency,note,amortization,createdAt);

@override
String toString() {
  return 'Transaction(id: $id, tripId: $tripId, type: $type, occurredAt: $occurredAt, sourceAccountId: $sourceAccountId, destAccountId: $destAccountId, categoryId: $categoryId, paidAmount: $paidAmount, paidCurrency: $paidCurrency, accountAmount: $accountAmount, accountCurrency: $accountCurrency, destAmount: $destAmount, destCurrency: $destCurrency, note: $note, amortization: $amortization, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String tripId, TransactionType type, DateTime occurredAt, String? sourceAccountId, String? destAccountId, String? categoryId, double paidAmount, CurrencyCode paidCurrency, double accountAmount, CurrencyCode accountCurrency, double? destAmount, CurrencyCode? destCurrency, String? note, Amortization? amortization, DateTime createdAt
});


@override $AmortizationCopyWith<$Res>? get amortization;

}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = null,Object? type = null,Object? occurredAt = null,Object? sourceAccountId = freezed,Object? destAccountId = freezed,Object? categoryId = freezed,Object? paidAmount = null,Object? paidCurrency = null,Object? accountAmount = null,Object? accountCurrency = null,Object? destAmount = freezed,Object? destCurrency = freezed,Object? note = freezed,Object? amortization = freezed,Object? createdAt = null,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destAccountId: freezed == destAccountId ? _self.destAccountId : destAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,paidCurrency: null == paidCurrency ? _self.paidCurrency : paidCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode,accountAmount: null == accountAmount ? _self.accountAmount : accountAmount // ignore: cast_nullable_to_non_nullable
as double,accountCurrency: null == accountCurrency ? _self.accountCurrency : accountCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode,destAmount: freezed == destAmount ? _self.destAmount : destAmount // ignore: cast_nullable_to_non_nullable
as double?,destCurrency: freezed == destCurrency ? _self.destCurrency : destCurrency // ignore: cast_nullable_to_non_nullable
as CurrencyCode?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,amortization: freezed == amortization ? _self.amortization : amortization // ignore: cast_nullable_to_non_nullable
as Amortization?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmortizationCopyWith<$Res>? get amortization {
    if (_self.amortization == null) {
    return null;
  }

  return $AmortizationCopyWith<$Res>(_self.amortization!, (value) {
    return _then(_self.copyWith(amortization: value));
  });
}
}

// dart format on
