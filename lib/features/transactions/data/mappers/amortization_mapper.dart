import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';

Map<String, dynamic> amortizationToJson(Amortization amortization) {
  return <String, dynamic>{
    'unit': amortization.unit.name,
    'count': amortization.count,
  };
}

Amortization amortizationFromJson(Map<String, dynamic> json) {
  final unit = AmortizationUnit.values.firstWhere(
    (value) => value.name == json['unit'] as String?,
    orElse: () => AmortizationUnit.days,
  );
  return Amortization(unit: unit, count: (json['count'] as num).toInt());
}
