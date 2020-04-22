import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/app_drawer.dart';
import './../providers/orders.dart';
import './../widgets/order_item.dart' as od;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-list';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (_, dataSnaphot) {
          print(dataSnaphot);
          if (dataSnaphot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (dataSnaphot.error != null) {
            return Center(
              child: Text(
                'something went wrong, try later',
                style: Theme.of(context).textTheme.title,
              ),
            );
          } else
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (_, index) {
                    return od.OrderItem(orderData.orders[index]);
                  },
                );
              },
            );
        },
      ),
    );
  }
}
