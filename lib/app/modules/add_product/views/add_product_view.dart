import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          TextField(
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
              //mengatasi ketika loading setelah di klik
              if (controller.isLoading.isFalse) {
                // proses add Product
                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil = await controller.addProduct({
                    "code": codeC.text,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);
                  Get.back();
                  Get.snackbar(
                      hasil["error"] ? "Error" : "Success", hasil["message"]);
                } else {
                  Get.snackbar("Error", "Semua data wajib diisi");
                }
              }
            },
            child: Obx(
              () => Text(
                  controller.isLoading.isFalse ? "AddProduct" : "Loading..."),
            ),
          )
        ],
      ),
    );
  }
}
