import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:encerrar_contrato/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow', (tester) async {
    const stepDelay = Duration(seconds: 2);

    app.main();
    await tester.pumpAndSettle();
    await tester.pump(stepDelay);

    final emailField = find.byKey(const Key('login_email'));
    final passwordField = find.byKey(const Key('login_password'));
    final loginButton = find.byKey(const Key('login_submit'));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '123456789');
    await tester.pump(stepDelay);

    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(stepDelay);
    await tester.pump(stepDelay);
  });
}
