import 'dart:convert';
import 'package:app_ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_ecommerce/model/model_product.dart';
import 'package:app_ecommerce/const.dart';
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:intl/intl.dart';

class DetailProductScreen extends StatefulWidget {
  final Datum product;

  const DetailProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String selectedColor = 'red';
  late String userId;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString("id") ?? '';
    });
  }

  void addToCart() async {
    // Ambil id_product dari widget.product.id
    String idProduct = widget.product.id.toString();

    // Ambil id_user dari sesi yang sudah disimpan sebelumnya
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("id");

    // Cek jika id_user tidak null
    if (userId != null) {
      // Siapkan data yang akan dikirim
      Map<String, String> data = {
        'id_product': idProduct,
        'id_user': userId,
      };

      // Kirim permintaan POST ke addtocart.php
      try {
        http.Response response = await http.post(
          Uri.parse('$url/addtocart.php'),
          body: data,
        );

        // Periksa status respons
        if (response.statusCode == 200) {
          // Parse JSON respons
          var jsonResponse = jsonDecode(response.body);
          bool isSuccess = jsonResponse['isSuccess'];
          String message = jsonResponse['message'];

          // Tampilkan pesan respons dalam snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: isSuccess ? Colors.green : Colors.red,
            ),
          );

          // Arahkan pengguna ke BottomNavBar()
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        } else {
          // Tampilkan pesan jika terjadi kesalahan dalam permintaan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.reasonPhrase}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Tangani kesalahan jika terjadi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Tampilkan pesan jika id_user tidak ditemukan dalam sesi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID not found in session.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        '$url/gambar/${widget.product.productImage}',
                        width: double.infinity,
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 30.0,
                        left: 10.0,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "Product Detail",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.productName,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 20.0),
                                SizedBox(width: 4.0),
                                Text(
                                  '4.8 (1k Reviews)',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              formatCurrency(int.parse(widget.product.productPrice)),
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Stock Available : ${widget.product.productStock}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Select Colour',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: ['white', 'red', 'blue', 'black'].map((color) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = color;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color == selectedColor ? Colors.red : Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 12.0,
                                    ),
                                    child: Text(
                                      color,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: color == selectedColor ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Select Quantity',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            IncrementDecrementFormField<int>(
                              initialValue: 0,
                              displayBuilder: (value, field) {
                                return Text(
                                  value == null ? "0" : value.toString(),
                                );
                              },
                              onDecrement: (currentValue) {
                                return currentValue! - 1;
                              },
                              onIncrement:(currentValue) {
                                return currentValue! + 1;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              widget.product.productDescription,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatCurrency(int.parse(widget.product.productPrice)),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addToCart,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
