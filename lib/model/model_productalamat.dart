// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

ModelProduct modelProductFromJson(String str) => ModelProduct.fromJson(json.decode(str));

String modelProductToJson(ModelProduct data) => json.encode(data.toJson());

class ModelProduct {
    bool isSuccess;
    String message;
    List<AddressDatum> data;

    ModelProduct({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelProduct.fromJson(Map<String, dynamic> json) => ModelProduct(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<AddressDatum>.from(json["data"].map((x) => AddressDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class AddressDatum {
    String id;
    String productName;
    String productPrice;
    String productStock;
    String productImage;
    String productDescription;
    String productCategory;
    String productAddress;

    AddressDatum({
        required this.id,
        required this.productName,
        required this.productPrice,
        required this.productStock,
        required this.productImage,
        required this.productDescription,
        required this.productCategory,
        required this.productAddress,
    });

    factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        id: json["id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productStock: json["product_stock"],
        productImage: json["product_image"],
        productDescription: json["product_description"],
        productCategory: json["product_category"],
        productAddress: json["product_address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_price": productPrice,
        "product_stock": productStock,
        "product_image": productImage,
        "product_description": productDescription,
        "product_category": productCategory,
        "product_address": productAddress,
    };
}
