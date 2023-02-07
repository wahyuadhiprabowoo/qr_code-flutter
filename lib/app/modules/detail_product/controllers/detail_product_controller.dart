import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxBool isLoadingUpdate = false.obs;
  RxBool isLoadingDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      // proses update product sukses
      await firestore
          .collection("products")
          .doc(data["id"])
          .update({"name": data["name"], "qty": data["qty"]});
      return {
        "error": false,
        "message": "Berhasil update product",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal mengupdate product",
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      // proses update product sukses
      await firestore.collection("products").doc(id).delete();
      return {
        "error": false,
        "message": "Berhasil menghapus product",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal menghapus product",
      };
    }
  }
}
