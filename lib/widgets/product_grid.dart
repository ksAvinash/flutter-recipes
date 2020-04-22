import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import './../providers/all_products.dart';

class ProductGridLayout extends StatelessWidget {
  final bool favouritesOnly;
  ProductGridLayout(this.favouritesOnly);

  @override
  Widget build(BuildContext context) {

    final items = favouritesOnly ? Provider.of<AllProducts>(context).favouritedItems : Provider.of<AllProducts>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
          value: items[index],
          child: ProductItem(),
        );
      },
      itemCount: items.length,
    );
  }
}
