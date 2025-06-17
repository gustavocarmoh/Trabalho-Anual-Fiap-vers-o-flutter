import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiap_20025/pages/create_account_page.dart';

void main() {
  testWidgets('Renderiza CreateAccountPage corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateAccountPage(),
      ),
    );

    expect(find.text('Criar Conta'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Confirmar Senha'), findsOneWidget);
  });

  testWidgets('Valida campos obrigatórios', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateAccountPage(),
      ),
    );

    await tester.tap(find.text('Criar Conta'));
    await tester.pump();

    expect(find.text('Informe seu nome'), findsOneWidget);
    expect(find.text('Informe um e-mail'), findsOneWidget);
    expect(find.text('Informe uma senha'), findsOneWidget);
    expect(find.text('Confirme sua senha'), findsOneWidget);
  });
}
