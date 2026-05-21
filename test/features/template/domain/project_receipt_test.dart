import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('derives receipt totals from stored inputs', () {
    const receipt = ProjectReceipt(track: ProjectTrack.engineering, seats: 3);

    expect(receipt.seatSubtotal, 144);
    expect(receipt.trackAddOn, 72);
    expect(receipt.subtotal, 336);
    expect(receipt.taxableSubtotal, 304);
    expect(receipt.tax, 24);
    expect(receipt.total, 328);
  });

  test('uses no track add-on before a track is selected', () {
    const receipt = ProjectReceipt(track: null, seats: 1);

    expect(receipt.trackAddOn, 0);
    expect(receipt.total, 147);
  });
}
