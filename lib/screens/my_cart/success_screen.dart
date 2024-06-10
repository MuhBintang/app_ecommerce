import 'dart:convert';

import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/main.dart';
import 'package:app_ecommerce/model/model_add.dart';
import 'package:app_ecommerce/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuccessPage extends StatefulWidget {
  final int? orderId;
  const SuccessPage(this.orderId, {Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool isLoading = false;
  String? id, username;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  String baseUrl = '$url';
  Future<void> deleteData(String? id, int? orderid) async {
    final url = Uri.parse('$baseUrl/success.php');
    final Map<String, dynamic> data = {'id_user': id, 'order_id': orderid};

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          print('Data deleted successfully!');
        } else {
          print('Failed to delete data: ${decodedResponse['message']}');
        }
      } else {
        print('Error deleting data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  Future<ModelAddjms?> update() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/success.php'),
          body: {"order_id": widget.orderId.toString(), "id_user": id});
      ModelAddjms data = modelAddjmsFromJson(res.body);
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
          );
        });

        // Tampilkan notifikasi pop-up
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pembayaran telah berhasil'),
            backgroundColor: Colors.green, // Warna hijau
            duration: Duration(seconds: 2), // Durasi notifikasi
          ),
        );
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
          setState(() {});
        });
      } else {
        setState(() {
          isLoading = false;
          setState(() {});
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            update();
          },
          style: ElevatedButton.styleFrom(primary: Color(0xFFEB3C3C)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Back to Home',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
