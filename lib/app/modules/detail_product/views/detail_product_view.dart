import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // inisialisasi data yang didapat dari database firestore
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = product.qty.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('DetailProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImage(
                  data: product.code,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          SizedBox(height: 48),
          TextField(
            // readOnly: true,
            enabled: false,
            autocorrect: false,
            controller: codeC,
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Product Code",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          SizedBox(height: 16),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                labelText: "Product Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          SizedBox(height: 16),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Product Quantity",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              // mengatasi ketika loading setelah di klik
              if (controller.isLoadingUpdate.isFalse) {
                // cek data kosong atau tidak
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoadingUpdate(true);
                  // proses update Product
                  Map<String, dynamic> hasil = await controller.updateProduct({
                    "id": product.productId,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  // update data selesai
                  controller.isLoadingUpdate(false);
                  // Get.back();
                  Get.snackbar(hasil["error"] == true ? "Error" : "Success",
                      hasil["message"],
                      duration: Duration(seconds: 2));
                } else {
                  Get.snackbar("Error", "Semua data wajib diisi",
                      duration: Duration(seconds: 2));
                }
              }
            },
            child: Obx(
              () => Text(controller.isLoadingUpdate.isFalse
                  ? "Update Product"
                  : "Loading..."),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Delete Product",
                  middleText: "Are you sure to delete this products",
                  actions: [
                    OutlinedButton(
                        onPressed: () => Get.back(), child: Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        // on delete product
                        controller.isLoadingDelete(true);
                        Map<String, dynamic> hasil =
                            await controller.deleteProduct(product.productId);

                        // proses hapus selesai
                        controller.isLoadingDelete(false);
                        Get.back(); //tutup dialog
                        Get.back(); //ke homescreen
                        Get.snackbar(
                            hasil["error"] == true ? "Error" : "Success",
                            hasil["message"],
                            duration: Duration(seconds: 2));
                      },
                      child: Obx(
                        () => controller.isLoadingDelete.isFalse
                            ? Text("Delete Product")
                            : Container(
                                height: 20,
                                width: 20,
                                padding: EdgeInsets.all(2),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                      ),
                    )
                  ]);
            },
            child: Text("Delete Product",
                style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }
}
