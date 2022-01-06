import 'package:bom_reading_tracker/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser? userFromFirebaseUser(User? user){
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream

  Stream<AppUser?> get user{
    return _auth.userChanges().map(userFromFirebaseUser);

  }
  Future signInAnon () async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      final User? uu = result.user;
      return userFromFirebaseUser(uu);
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  Future<AppUser?> register(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userFromFirebaseUser(result.user);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<AppUser?> signIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userFromFirebaseUser(result.user);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (ex) {
      print(ex.toString());
      return null;
    }

}
}