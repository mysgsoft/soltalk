import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soltalk/data/db/remote/response.dart';

class FirebaseAuthSource {
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<Response<UserCredential>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return Response.success(userCredential);
    } catch (e) {
      return Response.error((e.toString()));
    }
  }

  Future<Response<UserCredential>> register(
      String email, String password) async {
    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return Response.success(userCredential);
    } catch (e) {
      return Response.error((e.toString()));
    }
  }

  Future<Response<UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

          
      return Response.success(userCredential);
    } catch (e) {
      return Response.error(( e.toString()));
    }
    // Obtan the auth details from the request
  }
  
}
