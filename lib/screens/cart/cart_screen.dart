import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/models/cart_model.dart';

import '../../config/session.dart';
import '../../config/url.dart';
import '../../utils/snackbar__utils.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  final String userId;
  final VoidCallback onUpdate;

  CartScreen(
      {required this.userId, required this.onUpdate,required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }




  void _checkout() async {
    if (widget.cart.items.isEmpty) {
      SnackBarUtils.show(title: 'No Item in Cart', isError: true);
      return;
    }
    bool isLogin = await Session().isLogin();

    if (!isLogin) {
      SnackBarUtils.show(title: 'Please Login first', isError: true);
      return;
    }

    EasyLoading.show();
    try {
      Response response = await Dio().post(
        URL.bookDutyURL,
        data: FormData.fromMap({
          'cart': widget.cart.toJson(),
          'user_id': widget.userId,
          'grand_total': widget.cart.totalPrice,
          'start_date': DateTime.now().toUtc().toIso8601String(),
          'end_date': DateTime.now().toUtc().toIso8601String(),
        }),
      );

      Map<String, dynamic> data = response.data;
      if (data['error']) {
        EasyLoading.dismiss();
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        EasyLoading.dismiss();
        SnackBarUtils.show(title: data['message'], isError: false);
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
      EasyLoading.dismiss();
    }
    try {
      setState(() {
        widget.cart.items.clear();
        widget.onUpdate();
        Navigator.pop(context);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline_outlined,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              prefs.remove('cart');
              widget.cart.items.clear();
              widget.onUpdate();
              setState(()  {

              });
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: widget.cart != null ?
      ListView.builder(
        itemCount: widget.cart.items.length,
        itemBuilder: (context, index) {
          final item = widget.cart.items[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 35,
                backgroundImage: CachedNetworkImageProvider(
                  item.photo.split(',')[0],
                ),
              ),
              title: Text(
                '${item.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                'RM ${item.price}',
              ),
              trailing: Container(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (item.quantity == 1) {
                            //widget.cart.removeItem(item);

                          } else {
                            widget.cart.addItem(
                                CartItem(dutyId: item.dutyId, quantity: -1));
                          }
                          widget.onUpdate();
                        });
                      },
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.cart.addItem(
                            CartItem(dutyId: item.dutyId, quantity: 1),
                          );
                          widget.onUpdate();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ) : SizedBox(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _checkout,
        label: Text('Checkout (RM ${widget.cart.totalPrice})'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.blueGrey,
      ) ,
    );
  }

}
