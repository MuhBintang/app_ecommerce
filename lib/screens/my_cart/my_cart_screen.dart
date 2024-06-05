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
          products = modelListAddtoCartFromJson(res.body).data ?? [];
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

  int calculateTotal() {
    return products.fold(0, (sum, item) => sum + int.parse(item.productPrice) * item.quantity);
  }

  void updateQuantity(CardDatum product, int newQuantity) {
    setState(() {
      product.quantity = newQuantity;
    });
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
            child: products.isEmpty // Tambahkan penanganan jika produk kosong
                ? Center(
                    child: Text(
                      'Your cart is empty', // Tampilkan pesan ketika produk kosong
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      CardDatum product = products[index];
                      return Card(
                        color: Colors.white,
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: product.quantity > 1
                                              ? () {
                                                  updateQuantity(product, product.quantity - 1);
                                                }
                                              : null,
                                        ),
                                        Text(product.quantity.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            updateQuantity(product, product.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                formatCurrency(int.parse(product.productPrice) * product.quantity),
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
                  products.isEmpty // Ubah pesan total jika produk kosong
                      ? 'Total: ${formatCurrency(0)}'
                      : 'Total: ${formatCurrency(calculateTotal())}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: products.isEmpty ? null : () { // Nonaktifkan tombol jika produk kosong
                      // Navigasi ke CheckoutScreen saat tombol checkout ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(products: products, total: 1,),
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
