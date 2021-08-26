import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../providers/orders.dart' as provider;

class OrderItem extends StatefulWidget {
  final provider.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          _expanded ? min(widget.order.products.length * 20 + 110, 150) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            Container(
                //duration: Duration(microseconds: 300),
                height: _expanded
                    ? min(widget.order.products.length * 20 + 15, 95)
                    : 0,
                child: ListView(
                  children: [
                    ...widget.order.products
                        .map((prod) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prod.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    "${prod.quantity}x \$${prod.price.toStringAsFixed(2)}",
                                  )
                                ],
                              ),
                            ))
                        .toList()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
