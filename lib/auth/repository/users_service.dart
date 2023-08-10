import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //add user
  Future<void> addNewUser(User user) async {
    users
        .doc(user.uid)
        .set({'displayName': user.displayName, 'email': user.email})
        .then((value) => print('User Added!'))
        .catchError((error) => print('Can\'t add user: $error'));
  }

  //get user data
  Future<void> getUserData(String uid) async {
    //zmapować do danych uzytkownika
    //User user;
    users
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => print(snapshot.data()));
  }
  //delete user
}
