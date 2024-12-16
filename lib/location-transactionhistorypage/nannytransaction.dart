import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange for buttons
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown for titles
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class NannyTransactionPage extends StatefulWidget {
  const NannyTransactionPage({super.key});

  @override
  State<NannyTransactionPage> createState() => _NannyTransactionPageState();
}

class _NannyTransactionPageState extends State<NannyTransactionPage> {
  final List<Transaction> transactions = [
    Transaction(
      type: 'Service Fee',
      to: 'Kristine Lim',
      from: 'Alice Tan',
      paymentMethod: 'Cash',
      transactionId: '564925374920',
      date: '17 Oct 2023',
      time: '10:34 AM',
      amount: 2000.0,
      status: 'confirm',
      icon: Icons.account_balance_wallet,
    ),
    Transaction(
      type: 'Booking',
      to: 'Kristine Lim',
      from: 'Alice Tan',
      paymentMethod: 'Gpay',
      transactionId: '123456789',
      date: '16 Oct 2023',
      time: '14:00 PM',
      amount: 1800.0,
      status: 'confirm',
      icon: Icons.bookmark,
    ),
    Transaction(
      type: 'Payment',
      to: 'Kristine Lim',
      from: 'Alice Tan',
      paymentMethod: 'Bank Transfer',
      transactionId: '7890123456',
      date: '15 Oct 2023',
      time: '12:30 PM',
      amount: 2500.0,
      status: 'cancel',
      icon: Icons.money_off,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Nanny Transactions',
          style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Icon, Type, and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.beige,
                      child: Icon(
                        transaction.icon,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.coffeeBrown,
                          ),
                        ),
                        Text(
                          'From ${transaction.from}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Transaction Status
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.status == 'confirm'
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    transaction.status.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row for Amount, Date, and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₱ ${transaction.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                Text(
                  '${transaction.date} at ${transaction.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grayColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String type;
  final String from;
  final String to;
  final String transactionId;
  final String date;
  final String time;
  final double amount;
  final String status;
  final IconData icon;
  final String? paymentMethod;

  Transaction({
    required this.type,
    required this.from,
    required this.to,
    required this.transactionId,
    required this.date,
    required this.time,
    required this.amount,
    required this.status,
    required this.icon,
    this.paymentMethod,
  });
}
