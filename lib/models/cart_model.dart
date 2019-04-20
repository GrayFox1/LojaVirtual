import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;

  List<CartProduct> products = [];
  String cupomCode;
  double discountPerc = 0;
  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn()){
      loadCartItens();
    }
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then( (doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCupom(String cupomCode, double discountPerc){
    this.cupomCode = cupomCode;
    this.discountPerc = discountPerc;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.product != null){
        price += c.quantity * c.product.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * (discountPerc / 100); 
  }

  double getShipPrice(){
    return 9.90;
  }

  Future<String> finishOrder() async{
    if(products.length == 0) return null ;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double discount = getDiscount();
    double shipPrice = getShipPrice();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId" : user.firebaseUser.uid,
        "products" : products.map( (cartProduct) => cartProduct.toMap()).toList(),
        "shipPrice" : shipPrice,
        "productsPrice" : productsPrice,
        "discount" : discount,
        "totalPrice" : productsPrice - discount + shipPrice,
        "status" : 1  // Status do pedido
      }
    );

    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("orders").document(refOrder.documentID).setData(
      {
        "orderId" : refOrder.documentID
      }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }
    products.clear();
    cupomCode = null;
    discountPerc = 0.0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void loadCartItens() async{
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    products = query.documents.map( (doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}