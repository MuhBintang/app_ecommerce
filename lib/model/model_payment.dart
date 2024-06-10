// To parse this JSON data, do
//
//     final modelPayment = modelPaymentFromJson(jsonString);

import 'dart:convert';

ModelPayment modelPaymentFromJson(String str) => ModelPayment.fromJson(json.decode(str));

String modelPaymentToJson(ModelPayment data) => json.encode(data.toJson());

class ModelPayment {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelPayment({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelPayment.fromJson(Map<String, dynamic> json) => ModelPayment(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String idUser;
    String amount;
    String status;
    String snapToken;
    String orderId;
    String createdAt;
    String customerAddress;

    Datum({
        required this.id,
        required this.idUser,
        required this.amount,
        required this.status,
        required this.snapToken,
        required this.orderId,
        required this.createdAt,
        required this.customerAddress,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        idUser: json["id_user"],
        amount: json["amount"],
        status: json["status"],
        snapToken: json["snap_token"],
        orderId: json["order_id"],
        createdAt: json["created_at"],
        customerAddress: json["customer_address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "amount": amount,
        "status": status,
        "snap_token": snapToken,
        "order_id": orderId,
        "created_at": createdAt,
        "customer_address": customerAddress,
    };
}
