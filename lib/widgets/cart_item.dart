import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
class CartItem extends StatelessWidget {

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({ required this.id, required this.productId, required this.title, required this.price, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction)=> showDialog(context: (context), builder: (context)=>
             AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to remove the item?'),
              actions: <Widget>[
                TextButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child: Text('No')),
                TextButton(onPressed: (){
                  Navigator.of(context).pop(true);
                }, child: Text('Yes'))
              ],
            )),
      onDismissed: (direction){
          cart.removeItem(productId);
      },
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                    padding:EdgeInsets.all(3),
                    child: FittedBox(child:Text('\$$price', style: const TextStyle(color: Colors.white),))
                ),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${price * quantity}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
    );
  }
}
