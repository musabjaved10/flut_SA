import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null.toString(),
    price: 0,
    title: '',
    description: '',
    imageUrl: '',
  );

  @override
  void dispose() {
    //for freeing up memory by removing focusnodes
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    var isValidated = _form.currentState!.validate();
    if(!isValidated){
      return;
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    id: null.toString(),
                    price: _editedProduct.price,
                    title: value.toString(),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    id: null.toString(),
                    price: double.parse(value.toString()),
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter Price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please enter valid Price';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                onSaved: (value){
                  _editedProduct = Product(
                    id: null.toString(),
                    price: _editedProduct.price,
                    title: _editedProduct.title,
                    description: value.toString(),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Description is required';
                  }
                  if(value.length < 10){
                    return 'Description should atleast be 10 characters long';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter A URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text)),
                  ),
                  // SizedBox(width: 4,),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                          id: null.toString(),
                          price: _editedProduct.price,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: value.toString(),
                        );
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Image URL is required';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Field should be URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
