import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

final formKey = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

final nameController = TextEditingController();
final emailController = TextEditingController();
final passController = TextEditingController();
final addressController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text("FAZER LOGIN", style: TextStyle(fontSize: 15.0)),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            children: <Widget>[
              SizedBox(height: 130.0),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nome Completo",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Nome Inválido!";
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "E-mail inválido!";
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(hintText: "Senha"),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty || text.length < 4) return "Senha inválida!";
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Endereço",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Endereço Inválido!";
                },
              ),
              SizedBox(height: 40.0),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text("Cadastrar", style: TextStyle(fontSize: 18.0)),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (formKey.currentState.validate()) {

                      Map<String, dynamic> userData = {
                        "name" : nameController.text,
                        "email" : emailController.text,
                        "address": addressController.text
                      };
                      
                      model.signUp(userData: userData , pass: passController.text, onSuccess: onSuccess, onFail: onFail );
                      
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void onSuccess(){
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then( (_) {
      Navigator.of(context).pop();
    });
  }

  void onFail({@required String errorMsg, @required bool error}){
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(errorMsg, 
        textAlign: TextAlign.center,),
         backgroundColor: (error) ? Colors.redAccent : Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
  }
}
