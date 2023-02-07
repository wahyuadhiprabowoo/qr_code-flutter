import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(24),
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemBuilder: (context, index) {
          late String tittle;
          late IconData icon;
          late VoidCallback onTap; //callback untuk onTap
          // switch case data dari gridview builder
          switch (index) {
            case 0:
              tittle = "Add Product";
              icon = Icons.post_add_outlined;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 1:
              tittle = "Products";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.products);
              break;
            case 2:
              tittle = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () => controller.downloadCatalog();
              break;
            // case 2:
            //   tittle = "Qr-Code";
            //   icon = Icons.qr_code_outlined;
            //   onTap = () async {};

            // break;
          }
          return Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(icon, size: 50),
                    ),
                    SizedBox(height: 8),
                    Text(tittle),
                  ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Map<String, dynamic> hasil = await authC.logout();
            if (hasil["error"] == false) {
              Get.offAllNamed(Routes.login);
            } else {
              Get.snackbar("Error", hasil["error"]);
            }
          },
          child: Icon(Icons.logout)),
    );
  }
}
