import 'package:expense_project/models/transaction.dart';
import './bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactions {
    return List.generate(7, (index) {
      final wkd = DateTime.now().subtract(
        Duration(days: index),
      );
      var sum = 0.0;
      for (var x in recentTransactions) {
        if (x.date.day == wkd.day &&
            x.date.month == wkd.month &&
            x.date.year == wkd.year) {
          sum += x.amount;
        }
      }
      return {
        'day': DateFormat.E().format(wkd).substring(0, 1),
        'amount': sum,
      };
    }).reversed.toList();
  }

  double get mxSpend {
    return groupTransactions.fold(
      0.0,
      (sum, itm) {
        return sum + (itm['amount'] as double);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Bar(
                (data['day'] as String),
                (data['amount'] as double),
                mxSpend == 0.0 ? 0.0 : (data['amount'] as double) / mxSpend,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
