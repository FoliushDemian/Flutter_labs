import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Конвертер валют'),
        ),
        body: const CurrencyConverter(),
      ),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _controller = TextEditingController();
  final double _usdToUahRate = 37.5;
  String _result = '';

  void _convertCurrency() {
    final input = _controller.text.trim();

    if (input.toLowerCase() == 'рубль') {
      setState(() {
        _result = 'Доброго вечора ми з України';
      });
      return;
    }

    // Is input a number
    final numberRegExp = RegExp(r'^-?\d+(\.\d+)?$');
    if (!numberRegExp.hasMatch(input)) {
      setState(() {
        _result = 'Будь ласка, введіть число';
      });
      return;
    }

    final value = double.parse(input);
    setState(() {
      _result = 'Сума в гривнях: ${value * _usdToUahRate}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Сума в доларах',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _convertCurrency(),
          ),
        ),
        ElevatedButton(
          onPressed: _convertCurrency,
          child: const Text('Конвертувати'),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(_result),
        ),
      ],
    );
  }
}
