// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amortization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Amortization {

 AmortizationUnit get unit; int get count;
/// Create a copy of Amortization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmortizationCopyWith<Amortization> get copyWith => _$AmortizationCopyWithImpl<Amortization>(this as Amortization, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Amortization&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,unit,count);

@override
String toString() {
  return 'Amortization(unit: $unit, count: $count)';
}


}

/// @nodoc
abstract mixin class $AmortizationCopyWith<$Res>  {
  factory $AmortizationCopyWith(Amortization value, $Res Function(Amortization) _then) = _$AmortizationCopyWithImpl;
@useResult
$Res call({
 AmortizationUnit unit, int count
});




}
/// @nodoc
class _$AmortizationCopyWithImpl<$Res>
    implements $AmortizationCopyWith<$Res> {
  _$AmortizationCopyWithImpl(this._self, this._then);

  final Amortization _self;
  final $Res Function(Amortization) _then;

/// Create a copy of Amortization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? count = null,}) {
  return _then(_self.copyWith(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as AmortizationUnit,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Amortization].
extension AmortizationPatterns on Amortization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Amortization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Amortization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Amortization value)  $default,){
final _that = this;
switch (_that) {
case _Amortization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Amortization value)?  $default,){
final _that = this;
switch (_that) {
case _Amortization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AmortizationUnit unit,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Amortization() when $default != null:
return $default(_that.unit,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AmortizationUnit unit,  int count)  $default,) {final _that = this;
switch (_that) {
case _Amortization():
return $default(_that.unit,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AmortizationUnit unit,  int count)?  $default,) {final _that = this;
switch (_that) {
case _Amortization() when $default != null:
return $default(_that.unit,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _Amortization extends Amortization {
  const _Amortization({required this.unit, required this.count}): assert(count >= 1, 'amortization count must be at least 1'),super._();
  

@override final  AmortizationUnit unit;
@override final  int count;

/// Create a copy of Amortization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmortizationCopyWith<_Amortization> get copyWith => __$AmortizationCopyWithImpl<_Amortization>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Amortization&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,unit,count);

@override
String toString() {
  return 'Amortization(unit: $unit, count: $count)';
}


}

/// @nodoc
abstract mixin class _$AmortizationCopyWith<$Res> implements $AmortizationCopyWith<$Res> {
  factory _$AmortizationCopyWith(_Amortization value, $Res Function(_Amortization) _then) = __$AmortizationCopyWithImpl;
@override @useResult
$Res call({
 AmortizationUnit unit, int count
});




}
/// @nodoc
class __$AmortizationCopyWithImpl<$Res>
    implements _$AmortizationCopyWith<$Res> {
  __$AmortizationCopyWithImpl(this._self, this._then);

  final _Amortization _self;
  final $Res Function(_Amortization) _then;

/// Create a copy of Amortization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? count = null,}) {
  return _then(_Amortization(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as AmortizationUnit,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
