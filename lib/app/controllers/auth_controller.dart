import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //cek kondisi apakah ada autentifikasi/tidak
  // null -> tidak adaa user
  // uid -> ada user sedang login
  String? uid;
  late FirebaseAuth auth;
  Future<Map<String, dynamic>> login(String email, String pass) async {
    try {
      // proses login
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      return {"error": false, "message": "berhasil login"};
    } on FirebaseAuthException catch (e) {
      return {"error": true, "message": "${e.message}"};
    } catch (e) {
      return {"error": true, "message": "tidak dapat login"};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      // proses logout
      await auth.signOut();
      return {"error": false, "message": "berhasil logout"};
    } on FirebaseAuthException catch (e) {
      return {"error": true, "message": "${e.message}"};
    } catch (e) {
      return {"error": true, "message": "tidak dapat logout"};
    }
  }

  @override
  void onInit() {
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });
    super.onInit();
  }
}
