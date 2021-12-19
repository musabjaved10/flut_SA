import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item_tile.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
          title:const Text('Your Products'),
          actions: <Widget>[
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }, icon: const Icon(Icons.add))
          ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) => UserProductItemTile(title: productsData.items[index].title, imageUrl: productsData.items[index].imageUrl)
        ),

      ),

    );
  }
}
