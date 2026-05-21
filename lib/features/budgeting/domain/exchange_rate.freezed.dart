// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ExchangeRate {
  String get base => throw _privateConstructorUsedError;
  String get quote => throw _privateConstructorUsedError;
  double get rate => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeRateCopyWith<ExchangeRate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateCopyWith<$Res> {
  factory $ExchangeRateCopyWith(
    ExchangeRate value,
    $Res Function(ExchangeRate) then,
  ) = _$ExchangeRateCopyWithImpl<$Res, ExchangeRate>;
  @useResult
  $Res call({String base, String quote, double rate, DateTime date});
}

/// @nodoc
class _$ExchangeRateCopyWithImpl<$Res, $Val extends ExchangeRate>
    implements $ExchangeRateCopyWith<$Res> {
  _$ExchangeRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? quote = null,
    Object? rate = null,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            base: null == base
                ? _value.base
                : base // ignore: cast_nullable_to_non_nullable
                      as String,
            quote: null == quote
                ? _value.quote
                : quote // ignore: cast_nullable_to_non_nullable
                      as String,
            rate: null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExchangeRateImplCopyWith<$Res>
    implements $ExchangeRateCopyWith<$Res> {
  factory _$$ExchangeRateImplCopyWith(
    _$ExchangeRateImpl value,
    $Res Function(_$ExchangeRateImpl) then,
  ) = __$$ExchangeRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String base, String quote, double rate, DateTime date});
}

/// @nodoc
class __$$ExchangeRateImplCopyWithImpl<$Res>
    extends _$ExchangeRateCopyWithImpl<$Res, _$ExchangeRateImpl>
    implements _$$ExchangeRateImplCopyWith<$Res> {
  __$$ExchangeRateImplCopyWithImpl(
    _$ExchangeRateImpl _value,
    $Res Function(_$ExchangeRateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? quote = null,
    Object? rate = null,
    Object? date = null,
  }) {
    return _then(
      _$ExchangeRateImpl(
        base: null == base
            ? _value.base
            : base // ignore: cast_nullable_to_non_nullable
                  as String,
        quote: null == quote
            ? _value.quote
            : quote // ignore: cast_nullable_to_non_nullable
                  as String,
        rate: null == rate
            ? _value.rate
            : rate // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ExchangeRateImpl implements _ExchangeRate {
  const _$ExchangeRateImpl({
    required this.base,
    required this.quote,
    required this.rate,
    required this.date,
  });

  @override
  final String base;
  @override
  final String quote;
  @override
  final double rate;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'ExchangeRate(base: $base, quote: $quote, rate: $rate, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateImpl &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.quote, quote) || other.quote == quote) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, base, quote, rate, date);

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      __$$ExchangeRateImplCopyWithImpl<_$ExchangeRateImpl>(this, _$identity);
}

abstract class _ExchangeRate implements ExchangeRate {
  const factory _ExchangeRate({
    required final String base,
    required final String quote,
    required final double rate,
    required final DateTime date,
  }) = _$ExchangeRateImpl;

  @override
  String get base;
  @override
  String get quote;
  @override
  double get rate;
  @override
  DateTime get date;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
