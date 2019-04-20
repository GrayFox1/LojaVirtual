import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

  @override
  void addListener(listener) {
    super.addListener(listener);

    loadCurrentUser();
  }

    void signUp({@required Map<String, dynamic> userData, @required String pass, @required onSuccess, @required onFail}) async{
      isLoading = true;
      notifyListeners();

      try{
        firebaseUser = await auth.createUserWithEmailAndPassword(
        email: userData["email"], password: pass);

        await saveUserData(userData);
        onSuccess();
        isLoading = false;
        notifyListeners();

      } catch (e){
        print(e.message);
        onFail(errorMsg: e.message, error: true);
        isLoading = false;
        notifyListeners();
      }
    }

    void signIn({@required String email, @required String pass, @required onSuccess, @required onFail}) async{
      isLoading = true;
      notifyListeners();

      try{
        firebaseUser = await auth.signInWithEmailAndPassword(email: email, password: pass);
        await loadCurrentUser();
        onSuccess();
        isLoading = false;
        notifyListeners();

      } catch (e){
        print(e.message);
        onFail(errorMsg: e.message, error: true);
        isLoading = false;
        notifyListeners(); 
      }
    }

     void recoverPass(String email){
       auth.sendPasswordResetEmail(email: email);
    }


    void signOut() async{
      await auth.signOut();
      
      userData = Map();
      firebaseUser = null;
      notifyListeners();
    }

    bool isLoggedIn(){
      return firebaseUser != null;
    }

    Future<Null> saveUserData(Map<String, dynamic> userData){
      this.userData = userData;
      Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);

    }

    Future<Null> loadCurrentUser() async {
      if(firebaseUser == null)
        firebaseUser = await auth.currentUser();
      if(firebaseUser != null){
        if(userData["name"] == null){
          DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
          userData = docUser.data;
        }
      }
      notifyListeners();
    }
}