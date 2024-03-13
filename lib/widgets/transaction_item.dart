import 'package:flutter/material.dart';
import 'package:my_project/pages/transactions_page.dart';

Widget _dashboardItem(BuildContext context, String title, IconData icon) {
  return Card(
    child: InkWell(
      onTap: () {
        if (title == 'Transactions') {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const TransactionsPage(),),
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
