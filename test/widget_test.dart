import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_track/app.dart';

void main() {
  testWidgets('bottom navigation switches tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AutoTrackApp()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Service history'), findsOneWidget);

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    expect(find.text('Maintenance'), findsOneWidget);
  });

  testWidgets('quick action opens record form', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AutoTrackApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Refuel'));
    await tester.pumpAndSettle();
    expect(find.text('New record'), findsWidgets);
    expect(find.text('Type: fuel'), findsOneWidget);
  });
}
