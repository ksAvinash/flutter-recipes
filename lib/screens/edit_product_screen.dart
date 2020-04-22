import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/all_products.dart';
import './../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _descFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  var _initValues = {
    'title': '',
    'amount': '',
    'description': '',
    'imageUrl': '',
  };

  final _form = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();

  String _imageUrl = '';
  var _editedProduct = Product(
    id: DateTime.now().toString(),
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
    isFavourite: false,
  );
  var _isEditing = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _amountFocus.dispose();
    _descFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {
        _imageUrl = _imageUrlController.text;
      });
    }
  }

  Future<void> _saveForm(BuildContext context) async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() => _isLoading = true);
      if (_isEditing) {
        await Provider.of<AllProducts>(context, listen: false)
            .updateProduct(_editedProduct);
      } else {
        // try {
        await Provider.of<AllProducts>(context, listen: false)
            .addNewProduct(_editedProduct);
        // } catch (err) {
        //   await showDialog(
        //       context: context,
        //       builder: (ctx) {
        //         return AlertDialog(
        //           title: Text('Error Creating Item'),
        //           content: Text('something went wrong'),
        //           actions: <Widget>[
        //             FlatButton(
        //               onPressed: () => Navigator.of(ctx).pop(),
        //               child: Text('Ok'),
        //             )
        //           ],
        //         );
        //       });
        // }
      }
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      final passedProduct =
          ModalRoute.of(context).settings.arguments as Product;
      if (passedProduct != null) {
        _editedProduct = passedProduct;
        _isEditing = true;
        _imageUrl = passedProduct.imageUrl;
        _initValues = {
          'title': passedProduct.title,
          'amount': '${passedProduct.price}',
          'description': passedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = passedProduct.imageUrl;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(this.context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                autovalidate: true,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'enter the product title',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _priceFocus.requestFocus(),
                        validator: (val) {
                          if (val.isEmpty) return 'enter valid title';
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: val,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initValues['amount'],
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          hintText: 'enter the product amount',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val.isEmpty) return 'enter valid price amount';
                          if (double.tryParse(val) == null)
                            return 'invalid number';
                          if (double.parse(val) <= 0)
                            return 'enter number greater than zero';
                          return null;
                        },
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) => _descFocus.requestFocus(),
                        onSaved: (val) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(val),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initValues['description'],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'enter the product description',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocus,
                        validator: (val) {
                          if (val.isEmpty) return 'enter valid description';
                          if (val.length < 10) return 'too short';
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: val,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _imageUrl.isNotEmpty
                                ? Image.network(_imageUrl, fit: BoxFit.cover)
                                : Text('enter url',
                                    textAlign: TextAlign.center),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                                hintText: 'enter the image network url',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              onFieldSubmitted: (url) => _saveForm(context),
                              validator: (val) {
                                if (val.isEmpty) return 'enter valid image url';
                                if (!val.startsWith('http:') &&
                                    !val.startsWith('https:'))
                                  return 'invalid url';
                                return null;
                              },
                              onSaved: (val) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: val,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
