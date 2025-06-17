import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiap_20025/pages/planos_page.dart';

void main() {
  testWidgets('Renderiza PlanosPage com dia da semana', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlanosPage(diaSemana: 'Segunda-Feira'),
      ),
    );

    expect(find.textContaining('Plano de alimentação, Segunda-Feira'), findsOneWidget);
  });

  testWidgets('Renderiza PlanosPage sem dia da semana', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlanosPage(),
      ),
    );

    expect(find.text('Plano de alimentação'), findsWidgets);
  });
}
