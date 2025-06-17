import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiap_20025/pages/profile_page.dart';

void main() {
  testWidgets('Renderiza ProfilePage corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(),
      ),
    );

    expect(find.text('Julia Chagas'), findsOneWidget);
    expect(find.text('Plano Platina'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
  });

  testWidgets('Valida campo de e-mail', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(1), 'email_invalido');
    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });
}
