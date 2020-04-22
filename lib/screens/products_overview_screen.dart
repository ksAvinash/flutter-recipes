import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/all_products.dart';
import './../widgets/app_drawer.dart';
import './../providers/cart.dart';
import './../widgets/badge.dart';

import './../widgets/product_grid.dart';
import './cart_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

enum ProductFilters {
  FavouritesOnly,
  All,
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _favouritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<AllProducts>(context).fetchProductsFromServer().then((_) {
        setState(() => _isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShoppingApp'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: '${cart.totalCartItems()}',
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (val) {
              setState(() {
                if (val == ProductFilters.FavouritesOnly)
                  _favouritesOnly = true;
                else
                  _favouritesOnly = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favourites'),
                value: ProductFilters.FavouritesOnly,
              ),
              PopupMenuItem(
                child: Text('All Items'),
                value: ProductFilters.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () =>
                    Provider.of<AllProducts>(context, listen: false)
                        .fetchProductsFromServer(),
                child: ProductGridLayout(_favouritesOnly),
              ),
            ),
    );
  }
}
