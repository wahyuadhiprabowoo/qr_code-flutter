import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProductsView'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          builder: (context, snapProducts) {
            if (snapProducts.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // data dari firestore

            if (snapProducts.data!.docs.isEmpty) {
              //jika data kosong
              return Center(child: Text("No Product"));
            }
            // jika terdapat data
            List<ProductModel> allProducts = []; //buat list of model data
            for (var element in snapProducts.data!.docs) {
              allProducts.add(ProductModel.fromJson(
                  element.data())); //looping data dari json
            }

            return ListView.builder(
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                ProductModel product = allProducts[index];
                return Card(
                  margin: EdgeInsets.all(24),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: (() {
                      Get.toNamed(Routes.detailProduct, arguments: product);
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 100,
                      // color: Colors.grey.shade200,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Code Product: ${product.code}"),
                                SizedBox(height: 8),
                                Text("Name Product: ${product.name}"),
                                Text("Quantity: ${product.qty}"),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: QrImage(
                              data: product.code,
                              size: 200,
                              version: QrVersions.auto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
