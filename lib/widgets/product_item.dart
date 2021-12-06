import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // const ProductItem(
  //     {Key? key, required this.id, required this.title, required this.imageUrl})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return Consumer<Product>(
      builder: (context, product, _)=>  ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black54,
              leading: IconButton(
                icon: Icon( product.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  product.toggleIsFavorite();
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                        content: Text('Added item to cart'),
                        action: SnackBarAction(label: 'Undo', onPressed: (){
                          cart.removeSingleItem(product.id);
                        }),
                    )
                  );
                },
                color: Theme.of(context).colorScheme.secondary

              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }
}
