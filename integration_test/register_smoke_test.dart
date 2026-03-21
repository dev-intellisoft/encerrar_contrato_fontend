import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:encerrar_contrato/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register page smoke (close/transfer toggle)', (tester) async {
    const stepDelay = Duration(seconds: 2);

    app.main();
    await tester.pumpAndSettle();
    await tester.pump(stepDelay);

    final closeTab = find.byKey(const Key('register_tab_close'));
    final transferTab = find.byKey(const Key('register_tab_transfer'));

    expect(closeTab, findsOneWidget);
    expect(transferTab, findsOneWidget);

    // Default should be close
    expect(find.byKey(const Key('register_close_form')), findsOneWidget);

    // Switch to transfer
    await tester.tap(transferTab);
    await tester.pump();
    await tester.pump(stepDelay);
    expect(find.byKey(const Key('register_transfer_form')), findsOneWidget);

    // Switch back to close
    await tester.tap(closeTab);
    await tester.pump();
    await tester.pump(stepDelay);
    expect(find.byKey(const Key('register_close_form')), findsOneWidget);
  });
}
