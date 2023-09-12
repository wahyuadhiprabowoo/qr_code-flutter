import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  void downloadCatalog() async {
    // instance firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

    // buat pdf document
    final pdf = pw.Document();
    // proses ambil data dari firestore
    var getData = await firestore
        .collection("products")
        .get(); //ambil semua data dari database

    // reset allproducts untuk mengatasi duplikat
    allProducts([]);

    // lakukan looping pada data yang telah diambil
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    pdf.addPage(
      // Page untuk satu page, MultiPage untuk beberapa page
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            // List<pw.TableRow> allData = List.generate(1, (index) {});
            return [
              pw.Center(
                  child: pw.Text("Catalog Product",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 28, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 32),
              pw.Table(
                border: pw.TableBorder.all(
                    color: PdfColor.fromHex("#000000"), width: 2),
                children: [
                  pw.TableRow(children: [
                    // judul seperti no kodebarang qty
                    pw.Text("No",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Product Code",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Product Name",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Quantity",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("QR-Code",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]),
                  // isi data
                  ...List.generate(
                    allProducts.length,
                    (index) {
                      ProductModel product = allProducts[index];
                      return pw.TableRow(children: [
                        // jisi dari database firestore
                        pw.Text("${index + 1}"),
                        pw.Text("Product Code ${product.code}"),
                        pw.Text("Product Name ${product.name}"),
                        pw.Text("Quantity ${product.qty}"),
                        pw.BarcodeWidget(
                            height: 50,
                            width: 50,
                            color: PdfColor.fromHex("#000000"),
                            barcode: pw.Barcode.qrCode(),
                            data: product.code),
                      ]);
                    },
                  ),
                ],
              )
            ];
          }),
    );

    // uubah pdf ke byte lalu simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong lalu simpan pada directori
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/mydocument.pdf");

    // masukan bytes ke dalam file kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);

    // font
  }
}
