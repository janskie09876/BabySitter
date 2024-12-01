import 'package:flutter/material.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'transaction_detail_page.dart';

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
              AppStyles.primaryColor, // Use primaryColor from AppStyles
          elevation: 0,
          foregroundColor: Colors.black,
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
          color: AppStyles.primaryColor, // Use primaryColor from AppStyles
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: AppStyles
                      .defaultPadding, // Use defaultPadding from AppStyles
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
                  style: AppStyles
                      .primaryButtonStyle, // Use primaryButtonStyle from AppStyles
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
                      backgroundColor: const Color(0xFFF6A5A5),
                      radius: 20,
                      child: Icon(
                        transaction.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFEA7A6D),
                          ),
                        ),
                        Text(
                          'From ${transaction.from}',
                          style: const TextStyle(fontSize: 14),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                        style: const TextStyle(
                          color: Colors.white,
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
                  style: const TextStyle(fontSize: 12),
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
