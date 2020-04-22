import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/all_products.dart';
import './../providers/product.dart';
import './../screens/edit_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;
  ManageProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: product);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                try {
                  await Provider.of<AllProducts>(context, listen: false)
                      .deleteProductbyId(product.id);
                } catch (err) {
                  print(err);
                  scaffold.showSnackBar(
                    SnackBar(content: Text('deleting failed')),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
