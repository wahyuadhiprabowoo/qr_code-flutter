import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      // add product sukses
      var hasil = await firestore.collection("products").add(data);
      print("$data inii data");
      await firestore
          .collection("products")
          .doc(hasil.id)
          .update({"productId": hasil.id});
      return {
        "error": false,
        "message": "Berhasil menambah product",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal menambah product",
      };
    }
  }
}
