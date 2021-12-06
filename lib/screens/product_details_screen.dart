import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    // final loadedProduct = Provider.of<Products>(context).items.firstWhere((element) => element.id == productId);
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(id: productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover ,
              ),
            ),
            SizedBox(height: 10,),
            Text('\$${loadedProduct.price}', style: TextStyle(color: Colors.grey, fontSize: 20),),
            SizedBox(height: 10,),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('${loadedProduct.description}',textAlign: TextAlign.center, softWrap:true,),
                width: double.infinity,

            )
          ],
        ),
      ),
    );
  }
}
