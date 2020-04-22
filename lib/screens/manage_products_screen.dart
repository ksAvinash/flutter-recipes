import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';
import './../widgets/app_drawer.dart';
import './../widgets/manage_product_item.dart';
import './../providers/all_products.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    final allproducts = Provider.of<AllProducts>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<AllProducts>(context, listen: false).fetchProductsFromServer(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: ListView.builder(
            itemCount: allproducts.items.length,
            itemBuilder: (_, i) {
              return Column(
                children: <Widget>[
                  ManageProductItem(allproducts.items[i]),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
