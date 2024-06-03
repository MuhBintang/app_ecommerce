import 'package:flutter/material.dart';
import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_listaddtocart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'checkout_screen.dart'; // Import CheckoutScreen

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  String? username, id;
  List<CardDatum> products = []; // List untuk menyimpan produk di keranjang belanja

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      id = pref.getString("id") ?? '';
      print('id $id');
    });
    getProduct(); // Panggil fungsi getProduct() setelah mendapatkan sesi
  }

  Future<List<CardDatum>?> getProduct() async {
    try {
      http.Response res =
          await http.get(Uri.parse('$url/listaddtocart.php?id_user=$id'));
      if (res.statusCode == 200) {
        setState(() {
          products = modelListAddtoCartFromJson(res.body).data ?? []; // Perbarui list produk
        });
        return products;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to load data")));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  // Fungsi untuk menghapus produk dari keranjang belanja
  Future<void> deleteProduct(String productId) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$url/deletelistaddtocart.php'),
        body: {'id_product': productId, 'id_user': id},
      );
      if (res.statusCode == 200) {
        setState(() {
          getProduct();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'My Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                CardDatum product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        deleteProduct(product.productId);
                      },
                      child: Icon(Icons.delete, color: Colors.red,),
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: 57,
                          height: 57,
                          child: Image.network(
                            '$url/gambar/${product.productImage}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatCurrency(int.parse(product.productPrice)),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${formatCurrency(products.map((product) => int.parse(product.productPrice)).reduce((value, element) => value + element))}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigasi ke CheckoutScreen saat tombol checkout ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(products: products),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFEB3C3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
