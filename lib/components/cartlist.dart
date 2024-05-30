import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models&ReadCollectionModel/cartmodel.dart';

Padding cartList(
    String imgUrl, String restaurant, String foodName, double price, int id) {
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: ExpansionTile(
      minTileHeight: 70,
      shape: Border.all(color: Colors.black),
      textColor: Colors.black,
      collapsedBackgroundColor: Colors.deepOrange.shade100,
      collapsedTextColor: Colors.black,
      backgroundColor: Colors.white,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          imgUrl,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(
        ' $restaurant ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      subtitle: Text(
        '$foodName',
        style: TextStyle(
            letterSpacing: 2, fontWeight: FontWeight.w300, fontSize: 14),
      ),
      trailing: Consumer<CartModel>(builder: (context, value, child) {
        return IconButton(
            onPressed: () {
              value.remove(id);
            },
            icon: Text(
              'Remove',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ));
      }),
      children: <Widget>[
        Consumer<CartModel>(builder: (context, value, child) {
          return ListTile(
            leading: Icon(
              Icons.payments_outlined,
              color: Colors.black,
            ),
            textColor: Colors.blueGrey,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            title: Text('$price'),
            trailing: Text(
              {value.tPrice}.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
        }),
        ListTile(
          textColor: Colors.blueGrey,
          leading: Icon(
            Icons.call,
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          title: Text('$id'),
        ),
      ],
    ),
  );
}
