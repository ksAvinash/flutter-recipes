import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/all_products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productDetails = Provider.of<AllProducts>(context, listen: false)
        .getProductDetailsById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(productDetails.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(productDetails.imageUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              '\$${productDetails.price}',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Text(
                '${productDetails.description}',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
