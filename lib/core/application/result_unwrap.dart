import 'package:flutter_foundation_kit/core/result/result.dart';

T unwrapResult<T>(Result<T> result) {
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => throw failure,
  };
}
