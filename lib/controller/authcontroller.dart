// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:tugasakhir/model/usermodel.dart';

// class AuthController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection('users');

//   bool get success => false;

//   Future<UserModel?> registerWithEmailAndPassword(
//       String email, String password, String name) async {
//     try {
//       final UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       final User? user = userCredential.user;

//       if (user != null) {
//         final UserModel newUser =
//             UserModel(uName: name, uEmail: user.email ?? '', uId: user.uid);

//         await userCollection.doc(newUser.uId).set(newUser.toMap());

//         return newUser;
//       }
//     } catch (e) {
//       print('Error during registration: $e');
//     }
//     return null; // Return null if registration fails
//   }

//   Future<User?> signIn(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return _auth.currentUser;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // UserModel? getCurrentUser() {
//   //   final User? user = _auth.currentUser;

//   //   if (user != null) {
//   //     return UserModel.fromFirebaseUser(user);
//   //   }
//   //   return null;
//   // }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tugasakhir/model/usermodel.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool get success => false;

  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final UserModel newUser =
            UserModel(uName: name, uEmail: user.email ?? '', uId: user.uid);

        await userCollection.doc(newUser.uId).set(newUser.toMap());

        return newUser;
      }
    } catch (e) {
      print('Error during registration: $e');
    }
    return null; // Return null if registration fails
  }

  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
