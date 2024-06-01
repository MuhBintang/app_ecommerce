import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_ecommerce/const.dart';
import 'package:app_ecommerce/model/model_product.dart';
import 'detail_product_screen.dart';

class ListProductAll extends StatefulWidget {
  const ListProductAll({Key? key}) : super(key: key);

  @override
  State<ListProductAll> createState() => _ListProductAllState();
}

class _ListProductAllState extends State<ListProductAll> {
  List<Datum>? products;
  List<Datum>? filteredProducts;
  bool isLoading = true;

  Future<void> getProduct() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/listproduct.php'));
      products = modelProductFromJson(res.body).data;
      filteredProducts = products;
      setState(() {
        isLoading = false;
      });
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
    super.initState();
    getProduct();
  }

  void filterProducts(String query) {
    final filtered = products?.where((product) {
      final nameLower = product.productName.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('All Products', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => filterProducts(value),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Menambahkan border radius
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(8.0),
                    childAspectRatio: 0.75, // Menambah rasio aspek untuk memperbesar ukuran kartu
                    children: List.generate(filteredProducts!.length, (index) {
                      Datum product = filteredProducts![index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailProductScreen(product: product),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    '$url/gambar/${product.productImage}',
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: 150.0, // Memperbesar tinggi gambar
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${product.productPrice}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }
}