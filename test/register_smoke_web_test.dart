import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:encerrar_contrato/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register page smoke (close/transfer toggle) - web', (
    tester,
  ) async {
    const stepDelay = Duration(seconds: 2);

    app.main();
    await tester.pumpAndSettle();
    await tester.pump(stepDelay);

    final closeTab = find.byKey(const Key('register_tab_close'));
    final transferTab = find.byKey(const Key('register_tab_transfer'));

    expect(closeTab, findsOneWidget);
    expect(transferTab, findsOneWidget);

    expect(find.byKey(const Key('register_close_form')), findsOneWidget);

    await tester.tap(transferTab);
    await tester.pump();
    await tester.pump(stepDelay);
    expect(find.byKey(const Key('register_transfer_form')), findsOneWidget);

    await tester.tap(closeTab);
    await tester.pump();
    await tester.pump(stepDelay);
    expect(find.byKey(const Key('register_close_form')), findsOneWidget);
  });
}
