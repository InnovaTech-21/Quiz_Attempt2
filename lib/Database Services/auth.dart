import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //register with email and pass
  static Future<User?>loginUsingEmailPassword({required String email, required String password  }) async{
    User? user;
    try{

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      user =userCredential.user;

    }  on FirebaseAuthException catch(e){
      if(e.code =="user-not-found"){
        print("No user with that email");
      }
      else{

      }
    }
    return user;
  }


  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}