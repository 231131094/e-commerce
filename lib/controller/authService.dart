import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  Future <User?>signUp(String username, String email, String password)async{
    try{
      UserCredential response = await auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
    User? user = response.user;
    if(user!= null){
      await user.updateDisplayName(username);
      await user.reload();
      return auth.currentUser;
    }
    return user;

    }catch (e){
      print("Sign In Error : $e");
    }

  }
  
  Future <User?> loginGoogle(String email, String password)async{
    final GoogleSignInAccount? login = await GoogleSignIn().signIn(); 

  }
}
