import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiap_20025/pages/account_lost_page.dart';

void main() {
  testWidgets('Renderiza AccountLostPage corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AccountLostPage(),
      ),
    );

    expect(find.text('Recuperar Conta'), findsOneWidget);
    expect(find.text('Informe seu e-mail para recuperar sua conta'), findsOneWidget);
    expect(find.text('Recuperar'), findsOneWidget);
  });

  testWidgets('Valida campo de e-mail', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AccountLostPage(),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'email_invalido');
    await tester.tap(find.text('Recuperar'));
    await tester.pump();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });
}
