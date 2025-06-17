import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fiap_20025/pages/dashboard_page.dart';

void main() {
  testWidgets('Renderiza DashboardPage corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(),
      ),
    );

    expect(find.text('Supermercados Próximos'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
