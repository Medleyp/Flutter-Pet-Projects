import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_app/widgets/chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transactoin> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactoinValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;

      for (Transactoin tx in recentTransactions) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalSum += tx.amount;
        }
      }

      return {
        'day': DateFormat.EEEE().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactoinValues.fold(0.0, (sum, element) {
      return sum + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactoinValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactoinValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'].toString(),
                  spendingAmount: (data['amount'] as double),
                  spendingPctOfTotal: maxSpending == 0
                      ? 0.0
                      : ((data['amount'] as double) / maxSpending)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
