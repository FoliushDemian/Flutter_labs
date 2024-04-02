import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/pages/transactions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle subTextStyle =
      const TextStyle(fontSize: 16, color: Colors.green);

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoInternetDialog();
      }
    });
  }

  void _showNoInternetDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('You have lost connection to the internet.'
              ' Some features may not be available.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
            children: [
              Text('Welcome, User!', style: textStyle),
              SizedBox(height: isTablet ? 40 : 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 40 : 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 1,
                  childAspectRatio: 3 / 1,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _dashboardItem(
                      context,
                      'Transactions',
                      Icons.list_alt,
                    );
                  }
                  return _dashboardItem(context, 'Settings', Icons.settings);
                },
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
            children: [
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
