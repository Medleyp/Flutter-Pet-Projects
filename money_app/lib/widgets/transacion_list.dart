import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transactoin> _userTransactions;
  final Function _deleteTransaction;

  TransactionList({userTransaction, deleteTransaction})
      : _userTransactions = userTransaction,
        _deleteTransaction = deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: _userTransactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constrainst) {
              return Column(
                children: [
                  Text(
                    "No transactoin added yet!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constrainst.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemCount: _userTransactions.length,
              itemBuilder: (ctx, index) {
                return TransactionItem(
                  userTransaction: _userTransactions[index],
                  deleteTransaction: _deleteTransaction,
                );
              },
            ),
    );
  }
}
