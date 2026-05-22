// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amortization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Amortization {
  AmortizationUnit get unit => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Create a copy of Amortization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AmortizationCopyWith<Amortization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmortizationCopyWith<$Res> {
  factory $AmortizationCopyWith(
    Amortization value,
    $Res Function(Amortization) then,
  ) = _$AmortizationCopyWithImpl<$Res, Amortization>;
  @useResult
  $Res call({AmortizationUnit unit, int count});
}

/// @nodoc
class _$AmortizationCopyWithImpl<$Res, $Val extends Amortization>
    implements $AmortizationCopyWith<$Res> {
  _$AmortizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Amortization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? unit = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as AmortizationUnit,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AmortizationImplCopyWith<$Res>
    implements $AmortizationCopyWith<$Res> {
  factory _$$AmortizationImplCopyWith(
    _$AmortizationImpl value,
    $Res Function(_$AmortizationImpl) then,
  ) = __$$AmortizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AmortizationUnit unit, int count});
}

/// @nodoc
class __$$AmortizationImplCopyWithImpl<$Res>
    extends _$AmortizationCopyWithImpl<$Res, _$AmortizationImpl>
    implements _$$AmortizationImplCopyWith<$Res> {
  __$$AmortizationImplCopyWithImpl(
    _$AmortizationImpl _value,
    $Res Function(_$AmortizationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Amortization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? unit = null, Object? count = null}) {
    return _then(
      _$AmortizationImpl(
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as AmortizationUnit,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AmortizationImpl extends _Amortization {
  const _$AmortizationImpl({required this.unit, required this.count})
    : assert(count >= 1, 'amortization count must be at least 1'),
      super._();

  @override
  final AmortizationUnit unit;
  @override
  final int count;

  @override
  String toString() {
    return 'Amortization(unit: $unit, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmortizationImpl &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, unit, count);

  /// Create a copy of Amortization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AmortizationImplCopyWith<_$AmortizationImpl> get copyWith =>
      __$$AmortizationImplCopyWithImpl<_$AmortizationImpl>(this, _$identity);
}

abstract class _Amortization extends Amortization {
  const factory _Amortization({
    required final AmortizationUnit unit,
    required final int count,
  }) = _$AmortizationImpl;
  const _Amortization._() : super._();

  @override
  AmortizationUnit get unit;
  @override
  int get count;

  /// Create a copy of Amortization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AmortizationImplCopyWith<_$AmortizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
