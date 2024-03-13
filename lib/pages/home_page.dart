import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    final crossAxisCount = isTablet ? 4 : 2;

    final textStyle = isTablet ? const TextStyle(fontSize: 20,
        fontWeight: FontWeight.bold,) : const TextStyle(fontSize: 18,
        fontWeight: FontWeight.bold,);
    final subTextStyle = isTablet ? const TextStyle(fontSize: 18,
        color: Colors.green,) :
    const TextStyle(fontSize: 16, color: Colors.green);

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
              Text(
                'Welcome, User!',
                style: textStyle,
              ),
              SizedBox(height: isTablet ? 40 : 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Current Balance',
                        style: textStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$5,000.00',
                        style: subTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 40 : 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                childAspectRatio: isTablet ? 2 : 3 / 1,
                children: <Widget>[
                  _dashboardItem(context, 'Transactions', Icons.list_alt),
                  _dashboardItem(context, 'Budgets',
                      Icons.account_balance_wallet,),
                  _dashboardItem(context, 'Reports', Icons.pie_chart),
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
          if (title == 'Settings') {
            Navigator.pushNamed(context, '/profile');
          }
          // Add other navigation logic here as needed
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
