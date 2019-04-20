import 'package:flutter/material.dart';
import 'package:loja_virtual/Tabs/home_tab.dart';
import 'package:loja_virtual/Tabs/orders_tab.dart';
import 'package:loja_virtual/Tabs/places_tab.dart';
import 'package:loja_virtual/Tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(   // TELA 1 (HOME)
          body: HomeTab(),
          drawer: CustomDrawer(pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(   // TELA 2 (PRODUTOS)
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(  // TELA 3 (LOJAS)
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(pageController),
        ),
        Scaffold(  // TELA 4 (MEUS PEDIDOS)
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(pageController),
        )
      ],
  
    );
  }
}