// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  AccountType get type => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double get openingBalance => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call({
    String id,
    String tripId,
    String name,
    AccountType type,
    String currency,
    double openingBalance,
    String? icon,
    bool archived,
  });
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
    Object? openingBalance = null,
    Object? icon = freezed,
    Object? archived = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AccountType,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            openingBalance: null == openingBalance
                ? _value.openingBalance
                : openingBalance // ignore: cast_nullable_to_non_nullable
                      as double,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            archived: null == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
    _$AccountImpl value,
    $Res Function(_$AccountImpl) then,
  ) = __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tripId,
    String name,
    AccountType type,
    String currency,
    double openingBalance,
    String? icon,
    bool archived,
  });
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
    _$AccountImpl _value,
    $Res Function(_$AccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
    Object? openingBalance = null,
    Object? icon = freezed,
    Object? archived = null,
  }) {
    return _then(
      _$AccountImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AccountType,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        openingBalance: null == openingBalance
            ? _value.openingBalance
            : openingBalance // ignore: cast_nullable_to_non_nullable
                  as double,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        archived: null == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AccountImpl implements _Account {
  const _$AccountImpl({
    required this.id,
    required this.tripId,
    required this.name,
    required this.type,
    required this.currency,
    required this.openingBalance,
    this.icon,
    this.archived = false,
  });

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String name;
  @override
  final AccountType type;
  @override
  final String currency;
  @override
  final double openingBalance;
  @override
  final String? icon;
  @override
  @JsonKey()
  final bool archived;

  @override
  String toString() {
    return 'Account(id: $id, tripId: $tripId, name: $name, type: $type, currency: $currency, openingBalance: $openingBalance, icon: $icon, archived: $archived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.archived, archived) ||
                other.archived == archived));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tripId,
    name,
    type,
    currency,
    openingBalance,
    icon,
    archived,
  );

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account({
    required final String id,
    required final String tripId,
    required final String name,
    required final AccountType type,
    required final String currency,
    required final double openingBalance,
    final String? icon,
    final bool archived,
  }) = _$AccountImpl;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get name;
  @override
  AccountType get type;
  @override
  String get currency;
  @override
  double get openingBalance;
  @override
  String? get icon;
  @override
  bool get archived;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
