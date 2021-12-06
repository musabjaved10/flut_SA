import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart' as cartItemWidget;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                     ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 10,),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryTextTheme.headline5!.color),),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                      onPressed: (){
                        Provider.of<Orders>(context, listen: false).
                        addOrder(cart.items.values.toList(), cart.totalAmount);
                        cart.clearCart();
                      },
                      child: Text('Order Now'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.getItemCount,
                  itemBuilder: (context, index) => cartItemWidget.CartItem(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                  )
              )
          )
        ],
      ),
    );
  }
}
