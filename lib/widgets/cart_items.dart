import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final String productId;
  final double price;
  final int quantity;

  CartItem({
    @required this.title,
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              elevation: 6,
              title: Text('Are you sure?'),
              content: Text('Do you want to permanently delete the item from the cart?'),
              actions: <Widget>[
                FlatButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('No')),
                FlatButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Yes')),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(Icons.delete_outline, color: Colors.white),
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
              radius: 35,
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Chip(label: Text('${quantity}x')),
          ),
        ),
      ),
    );
  }
}
