import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../providers/orders.dart' as od;

class OrderItem extends StatefulWidget {
  final od.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat.yMMMEd().format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 50, 180),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('${widget.order.products[i].title}'),
                          Text('${widget.order.products[i].quantity}x'),
                        ],
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
