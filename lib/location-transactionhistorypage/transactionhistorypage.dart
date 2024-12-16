import 'package:flutter/material.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'transaction_detail_page.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final List<Transaction> allTransactions = [
    Transaction(
      type: 'Booking',
      to: 'Kristine Lim',
      from: 'Alice Tan',
      paymentMethod: 'Cash',
      transactionId: '564925374920',
      date: '17 Oct 2023',
      time: '10:34 AM',
      amount: 2000.0,
      status: 'confirm',
      icon: Icons.bookmark,
    ),
    Transaction(
      type: 'Transfer Money',
      to: 'Kristine Lim',
      paymentMethod: 'Gpay',
      accountNo: '09051523352',
      bank: '',
      from: 'Alice Tan',
      transactionId: '',
      date: '16 Oct 2023',
      time: '16:08 PM',
      amount: 2000.0,
      status: 'confirm',
      icon: Icons.account_balance_wallet,
      receiveDate: 'Sept. 16, 2023',
    ),
    Transaction(
      type: 'Booking',
      to: 'Kristine Lim',
      from: 'Alice Tan',
      paymentMethod: 'Cash',
      transactionId: '564925374920',
      date: '17 Oct 2023',
      time: '10:34 AM',
      amount: 2000.0,
      status: 'cancel',
      icon: Icons.bookmark,
    ),
  ];

  String selectedFilter = 'All';
  List<Transaction> displayedTransactions = [];

  @override
  void initState() {
    super.initState();
    _filterTransactions();
  }

  void _filterTransactions() {
    setState(() {
      List<Transaction> filteredTransactions = selectedFilter == 'All'
          ? allTransactions
          : allTransactions.where((t) => t.type == selectedFilter).toList();

      displayedTransactions = filteredTransactions.take(10).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
          backgroundColor:
              AppColors.primaryColor, // Use primaryColor from AppColors
          elevation: 0,
          foregroundColor:
              AppColors.blackColor, // Use blackColor from AppColors
          bottom: TabBar(
            onTap: (index) {
              String newFilter = 'All';

              if (index == 1) newFilter = 'Booking';
              if (index == 2) newFilter = 'Transfer Money';

              if (newFilter != selectedFilter) {
                selectedFilter = newFilter;
                _filterTransactions();
              }
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Booking'),
              Tab(text: 'Transfer Money'),
            ],
          ),
        ),
        body: Container(
          color:
              AppColors.lightBackground, // Use lightBackground from AppColors
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(
                      16.0), // Padding can also be adjusted here
                  itemCount: displayedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = displayedTransactions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailPage(
                              details: {
                                'Type': transaction.type,
                                'Amount':
                                    '₱${transaction.amount.toStringAsFixed(2)}',
                                'To': transaction.to,
                                'From': transaction.from,
                                if (transaction.paymentMethod != null &&
                                    transaction.paymentMethod!.isNotEmpty)
                                  'Payment Method': transaction.paymentMethod!,
                                if (transaction.accountNo != null &&
                                    transaction.accountNo!.isNotEmpty)
                                  'Account Number': transaction.accountNo!,
                                'Date': transaction.date,
                                'Time': transaction.time,
                                'Status': transaction.status,
                              },
                              icon: transaction.icon, // Pass the icon here
                            ),
                          ),
                        );
                      },
                      child: TransactionCard(transaction: transaction),
                    );
                  },
                ),
              ),
              if (allTransactions
                      .where((t) =>
                          selectedFilter == 'All' || t.type == selectedFilter)
                      .length >
                  10)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      displayedTransactions = allTransactions
                          .where((t) =>
                              selectedFilter == 'All' ||
                              t.type == selectedFilter)
                          .toList();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.whiteColor,
                    backgroundColor:
                        AppColors.primaryColor, // Text color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Load More'),
                ),
            ],
          ),
        ),
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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.beige, // Use beige from AppColors
                      radius: 20,
                      child: Icon(
                        transaction.icon,
                        color: AppColors
                            .whiteColor, // Use whiteColor from AppColors
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors
                                .coffeeBrown, // Use coffeeBrown from AppColors
                          ),
                        ),
                        Text(
                          'From ${transaction.from}',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors
                                  .grayColor), // Use grayColor from AppColors
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₱ ${transaction.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors
                            .blackColor, // Use blackColor from AppColors
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: transaction.status == 'confirm'
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        transaction.status,
                        style: TextStyle(
                          color: AppColors
                              .whiteColor, // Use whiteColor from AppColors
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.date,
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          AppColors.grayColor), // Use grayColor from AppColors
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
  final String? bank;
  final String? accountNo;
  final String? receiveDate;

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
    this.bank,
    this.accountNo,
    this.receiveDate,
  });
}
