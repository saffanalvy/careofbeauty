import 'package:firebase_auth/firebase_auth.dart';
import 'toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //Signing out
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      toast("Signed out");
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      toast(e.message);
      return e.message;
    } catch (e) {
      toast(e.message);
      return e.message;
    }
  }

  //Singing in with Email
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      toast("Welcome " + email);
      return "Welcome " + email;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("User not found");
        return "User not found";
      }
      toast(e.message);
      return e.message;
    } catch (e) {
      toast(e.message);
      return e.message;
    }
  }

  //Guest signin
  Future<String> guestSignIn() async {
    try {
      await _firebaseAuth.signInAnonymously();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_firebaseAuth.currentUser.uid)
          .set({'skintone': 'None'});
      toast("Welcome guest");
      return "Welcome guest";
    } on FirebaseAuthException catch (e) {
      toast(e.message);
      return e.message;
    } catch (e) {
      toast(e.message);
      return e.message;
    }
  }

  //Regstering user with email
  Future<String> register({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(_firebaseAuth.currentUser.uid)
          .set({'skintone': 'None'});

      toast("Congratulations! Welcome " + email);
      return "Congratulations! Welcome " + email;
    } on FirebaseAuthException catch (e) {
      toast(e.message);
      return e.message;
    }
  }
}
