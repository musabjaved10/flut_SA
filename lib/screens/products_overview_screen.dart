import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {

  var _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue){
                setState(() {
                  if(selectedValue == FilterOptions.Favourites){
                    _showFavoritesOnly = true;
                  }else{
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(child: Text('Favorites'), value: FilterOptions.Favourites,),
                const PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
              ]
          ),
          Consumer<Cart>(
            builder: (context, cartData, badgeChild) => Badge(
                child: badgeChild!,
                value: cartData.getItemCount.toString(),
                color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
              onPressed: ()=> Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}


