import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadorarodrigolopezjimenez/main.dart';

void main() {
  testWidgets('Calculadora muestra display inicial en 0', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculadoraApp());
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Botón 5 añade "5" a la expresión', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculadoraApp());
    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();
    expect(find.text('5'), findsWidgets);
  });

  testWidgets('C limpia la expresión', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculadoraApp());
    await tester.tap(find.widgetWithText(ElevatedButton, '9'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'C'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
