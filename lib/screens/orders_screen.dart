import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';


  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).fetchOrders(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  //do error-handling here
                  return const Center(
                    child: Text('Error occurred.'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (context, orderData, child) =>
                          ListView.builder(
                              itemCount: orderData.orders.length,
                              itemBuilder: (context, index) =>
                                  OrderItemTile(orderData.orders[index])));
                }
              }
            }));
  }
}
