import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard,),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("cupons").document(text).get().then(
                  (snap){
                    if(snap.data != null){ // CUPOM VÁLIDO
                      CartModel.of(context).setCupom(text, snap.data["percent"].toDouble());
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Desconto de ${snap.data["percent"]}% aplicado!", textAlign: TextAlign.center),
                        backgroundColor: Theme.of(context).primaryColor,
                        ), 
                      );
                    }
                    else{
                      CartModel.of(context).setCupom(null, 0);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom inválido!", textAlign: TextAlign.center), 
                        backgroundColor: Colors.redAccent
                        )
                      );
                    }
                  }
                );
              },
            ),
          )
        ],
      )
    );
  }
}