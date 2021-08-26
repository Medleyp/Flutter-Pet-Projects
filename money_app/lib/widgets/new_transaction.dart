import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountCotroller = TextEditingController();
  DateTime? _selectedDate;

  void _submidData(DateTime? enteredDate) {
    if (_amountCotroller.text.isEmpty ||
        _titleController.text.isEmpty ||
        enteredDate == null) {
      return;
    }

    final enteredTitle = _titleController.text;
    final eneteredAmount = double.parse(_amountCotroller.text);

    if (eneteredAmount <= 0) {
      return;
    }

    widget.addTx(
      enteredTitle,
      eneteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _submidData(_selectedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submidData(_selectedDate),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountCotroller,
                onSubmitted: (_) => _submidData(_selectedDate),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Choosen!"
                          : DateFormat.yMd()
                              .format(_selectedDate as DateTime))),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: Text(
                            "Chose Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _presentDatePicker,
                        )
                      : TextButton(
                          child: Text(
                            "Chose Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          onPressed: _presentDatePicker,
                        )
                ],
              ),
              ElevatedButton(
                child: Text('Add Transaction'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: () => _submidData(_selectedDate),
              )
            ],
          ),
        ),
      ),
    );
  }
}
