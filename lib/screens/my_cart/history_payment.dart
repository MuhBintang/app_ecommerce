import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'order_tracking_screen.dart';

class HistoryPaymentScreen extends StatefulWidget {
  const HistoryPaymentScreen({Key? key}) : super(key: key);

  @override
  State<HistoryPaymentScreen> createState() => _HistoryPaymentScreenState();
}

class _HistoryPaymentScreenState extends State<HistoryPaymentScreen> {
  String? username, id, address;
  bool isLoading = true;
  List<Datum>? payments;

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
      address = pref.getString("address");
    });
    getPayment();
  }

  Future<void> getPayment() async {
    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse('$url/getPayment.php'));
      if (res.statusCode == 200) {
        setState(() {
          payments = modelPaymentFromJson(res.body).data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load payments.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Payments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : payments == null || payments!.isEmpty
              ? Center(child: Text('No payment history found.'))
              : ListView.builder(
                  itemCount: payments!.length,
                  itemBuilder: (context, index) {
                    Datum payment = payments![index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Payment ID: ${payment.orderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount: ${payment.amount}'),
                            Text('Date: ${payment.createdAt}'),
                            Text('Status: ${payment.status}'),
                            // Tambahkan field lain sesuai dengan struktur data Anda
                          ],
                        ),
                        onTap: () {
                          // Navigasi ke halaman OrderTrackingScreen dengan mengirim payment sebagai argumen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
