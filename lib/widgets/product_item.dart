import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/product.dart';
import './../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    print('favourite status; ${product.isFavourite}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(product.title, textAlign: TextAlign.center),
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: product.toggleFavourite,
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (_, cart, child) => IconButton(
                icon: Icon(
                  cart.isItemCarted(product.id)
                      ? Icons.add_shopping_cart
                      : Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addToCart(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to cart!'),
                      duration: Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
