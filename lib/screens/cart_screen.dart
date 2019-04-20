import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: 10.0),
              alignment: Alignment.center,
              child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                int qtd = model.products.length;
                return Text("${qtd ?? 0} ${qtd == 1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(fontSize: 16.0));
              }))
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(child: CircularProgressIndicator());
          } 
          else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(35.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                      size: 80.0, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16.0),
                  Text("Faça o login para adicionar produtos!",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    child: Text("Login", style: TextStyle(fontSize: 18.0,)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              ),
            );
          }
          else if(model.products == null || model.products.length == 0){
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.shopping_cart, size: 80.0, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16.0),
                  Text("Carrinho vazio! :(",
                    style: TextStyle(fontSize: 20.0, 
                    fontWeight: FontWeight.bold), 
                    textAlign: TextAlign.center,)
                ],
              ),
            );
          }
          else{  // LOGADO E QTD PROD > 0
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                    (product){
                      return CartTile(product);
                    }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice( () async {
                  String orderId = await model.finishOrder();
                  if(orderId != null){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute( builder: (context) => OrderScreen(orderId))
                    );
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
