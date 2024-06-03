import 'package:flutter/material.dart';
import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_listaddtocart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CardDatum> products;

  const CheckoutScreen({Key? key, required this.products}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? total;
  String? address, username, email;

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email");
      address = pref.getString("address");
      username = pref.getString("username");
    });
  }

  Future<void> calculateTotalPrice() async {
    int totalPrice = widget.products
        .map((product) => int.parse(product.productPrice))
        .reduce((value, element) => value + element);
    setState(() {
      total = formatCurrency(totalPrice);
    });
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove drop shadow
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true, // Center the title
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'House',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      address ?? 'No address found',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product List Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                CardDatum product = widget.products[index];
                return ListTile(
                  leading: SizedBox(
                    width: 57,
                    height: 57,
                    child: Image.network(
                      '$url/gambar/${product.productImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.productName),
                  subtitle: Text(
                    formatCurrency(int.parse(product.productPrice)),
                  ),
                  trailing: Text('Stock left: ${product.productStock}'),
                );
              },
            ),
          ),
          // Payment Method Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.payment, size: 40),
            title: Text('Credit/Debit Card'),
            subtitle: Text(email ?? 'user****@gmail.com'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Payment method logic
            },
          ),
          // Total Amount Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              total ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Checkout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Checkout logic
                },
                child: Text('Checkout Now'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Border radius
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
