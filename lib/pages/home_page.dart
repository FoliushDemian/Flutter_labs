import 'package:flutter/material.dart';
import 'package:my_project/logic/services/transaction_service.dart';
import 'package:my_project/pages/transactions_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _currentBalance;

  final TextStyle subTextStyle =
      const TextStyle(fontSize: 16, color: Colors.green);
  final transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    transactionService.onBalanceUpdated = _loadBalance;
    _loadBalance();
  }

  @override
  void dispose() {
    transactionService.onBalanceUpdated = null;
    super.dispose();
  }

  void _loadBalance() async {
    final balance = await getCurrentBalance();
    if (mounted) {
      setState(() {
        _currentBalance = balance;
      });
    }
  }

  Future<double> getCurrentBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(TransactionService.currentBalanceKey) ?? 5000.00;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final textStyle = TextStyle(
      fontSize: isTablet ? 20 : 18,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Welcome, User!', style: textStyle),
              SizedBox(height: isTablet ? 40 : 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Balance', style: textStyle),
                      const SizedBox(height: 10),
                      if (_currentBalance != null)
                        Text(
                          '\$${_currentBalance!.toStringAsFixed(2)}',
                          style: subTextStyle,
                        ),
                      if (_currentBalance == null)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 40 : 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isTablet ? 2 : 1,
                childAspectRatio: 3 / 1,
                children: [
                  _dashboardItem(context, 'Transactions', Icons.list_alt),
                  _dashboardItem(context, 'Settings', Icons.settings),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardItem(BuildContext context, String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {
          if (title == 'Transactions') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const TransactionsPage(),
              ),
            );
          } else if (title == 'Settings') {
            Navigator.pushNamed(context, '/profile');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 24),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
