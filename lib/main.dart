import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculadoraApp());
}

String _evaluarExpresion(String expr) {
  try {
    final normalizada = expr.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');
    final exp = ShuntingYardParser().parse(normalizada);
    final resultado = exp.evaluate(EvaluationType.REAL, ContextModel()) as double;
    if (resultado == resultado.truncateToDouble()) {
      return resultado.truncate().toString();
    }
    return resultado.toString();
  } catch (_) {
    return 'Error';
  }
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _expresion = '';
  String _resultado = '';

  void _onPressed(String label) {
    setState(() {
      if (label == 'C') {
        _expresion = '';
        _resultado = '';
      } else if (label == '←') {
        if (_expresion.isNotEmpty) {
          _expresion = _expresion.substring(0, _expresion.length - 1);
          _resultado = '';
        }
      } else if (label == '=') {
        if (_expresion.isNotEmpty) {
          _resultado = _evaluarExpresion(_expresion);
          if (_resultado != 'Error') {
            _expresion = _resultado;
            _resultado = '';
          }
        }
      } else {
        _resultado = '';
        _expresion += label;
      }
    });
  }

  Widget _buildButton(String label, {Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.grey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: () => _onPressed(label),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorOperador = Colors.orange[700]!;
    final colorEspecial = Colors.grey[700]!;

    final filas = [
      ['C', '(', ')', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['←', '0', '.', '='],
    ];

    Color colorBoton(String label) {
      if (label == '=' || label == '÷' || label == '×' || label == '−' || label == '+') {
        return colorOperador;
      }
      if (label == 'C' || label == '(' || label == ')' || label == '←') {
        return colorEspecial;
      }
      return Colors.grey[800]!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            color: Colors.grey[850],
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expresion.isEmpty ? '0' : _expresion,
                    style: const TextStyle(fontSize: 36, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  if (_resultado.isNotEmpty)
                    Text(
                      _resultado,
                      style: TextStyle(fontSize: 22, color: Colors.orange[300]),
                      textAlign: TextAlign.end,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: filas.map((fila) {
                  return Expanded(
                    child: Row(
                      children: fila.map((label) => _buildButton(label, bgColor: colorBoton(label))).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
