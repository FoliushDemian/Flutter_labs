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
  // ignore: library_private_types_in_public_api
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _controller = TextEditingController();
  // ignore: lines_longer_than_80_chars
  final double _usdToUahRate = 37.5; 
  String _result = '';

  void _convertCurrency() {
    final input = _controller.text;
    if (input.toLowerCase() == 'рубль') {
      setState(() {
        _result = 'Доброго вечора ми з України';
      });
    } else {
      final value = double.tryParse(input);
      if (value != null) {
        setState(() {
          _result = 'Сума в гривнях: ${value * _usdToUahRate}';
        });
      } else {
        setState(() {
          _result = 'Будь ласка, введіть коректне число';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Сума в доларах',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
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
