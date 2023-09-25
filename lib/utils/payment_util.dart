import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:travel/utils/snackbar__utils.dart';


import '../config/session.dart';
import '../config/url.dart';
import '../screens/paymrnt_status_screen.dart';
import '../screens/senangpay-form-screen.dart';

class PaymentUtils{
  String merchantId = '827169018481024';
  String secretKey = '39853-2042292850';
  String generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_$timestamp';
  }

  Future<void> makePayment(String details, double ammount,String order_Id, String nameU, String emailU, String phoneU,data,String type,BuildContext context) async {;
    try {
      // 1. Set the payment details
      String merchantId = '827169018481024';
      String secretKey = '39853-2042292850';
      String detail = details;
      double amount = ammount;
      String orderId = order_Id;
      String name = nameU;
      String email = emailU;
      String phone = phoneU;
      // 2. Calculate the hash (You may need to implement your hash generation logic)
      String hash = generateSecureHash(secretKey, detail, amount, orderId);
      print(hash);
      print(orderId);

      print(verifySecureHash(hash, secretKey, detail, amount, orderId));
      // 3. Create the payment request data
      Map<String, dynamic> paymentData = {
        'detail': detail,
        'amount': amount.toStringAsFixed(2),
        'order_id': orderId,
        'hash': hash,
        'name': name,
        'email': email,
        'phone': phone,
      };

      // 4. Send a POST request to the SenangPay API
      String paymentUrl = 'https://app.senangpay.my/payment/$merchantId';
      final response =
      await http.post(Uri.parse(paymentUrl), body: paymentData);
      if (response.statusCode == 200) {
        print('Payment initiated successfully');
        String responseBody = response.body;
        print(responseBody);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SenangPayFormScreen(htmlForm: responseBody,data: data,type: type,),

        ));

      } else {
        // 6. Handle errors or failures
        print('Payment initiation failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // 7. Handle exceptions
      print('An error occurred during payment initiation: $e');
    }
  }

  bool verifySecureHash(String receivedHash, String secretKey, String detail,
      double amount, String orderId) {
    String expectedHash =
    generateSecureHash(secretKey, detail, amount, orderId);
    return receivedHash == expectedHash;
  }

  String generateSecureHash(
      String secretKey, String detail, double amount, String orderId) {
//     String combinedS =
//         '827169018481024${secretKey}$orderId';
//
//     Uint8List bytesS = Uint8List.fromList(utf8.encode(combinedS));
//
//     Hmac hmacS = Hmac(sha256, utf8.encode(secretKey)); // or use md5 as needed
//     Digest digestS = hmacS.convert(bytesS);
//
// print('hashh 2: $digestS');
    String combinedString =
        '$secretKey$detail${amount.toStringAsFixed(2)}$orderId';

    Uint8List bytes = Uint8List.fromList(utf8.encode(combinedString));

    Hmac hmac = Hmac(sha256, utf8.encode(secretKey)); // or use md5 as needed
    Digest digest = hmac.convert(bytes);
    return digest.toString();
  }

  Future<String> checkOrderStatus(String orderId) async {
    String combinedString =
        '$merchantId$secretKey$orderId';
    Uint8List bytes = Uint8List.fromList(utf8.encode(combinedString));
    Hmac hmac = Hmac(sha256, utf8.encode(secretKey)); // or use md5 as needed
    Digest digest = hmac.convert(bytes);

    final response = await http.get(Uri.parse('https://app.senangpay.my/apiv1/query_order_status?merchant_id=$merchantId&order_id=$orderId&hash=$digest'));
    print('check Status');
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      if(data != null){
        final status = data['data'][0]['payment_info']['status'];
        return status;
      }else{
        return 'failed';
      }

    }else{
      return 'failed';
    }

  }
}

class Booking {
  void bookCar(totalPrice, start_date, end_date,BuildContext context) async {
    Map sessionUser = await Session().user();
    bool isLogin = await Session().isLogin();
    if (isLogin) {
      EasyLoading.show();
      try {
        final response = await Dio().post(
          URL.bookCarURL,
          data: FormData.fromMap({
            'car_id': Get.parameters['id'],
            'user_id': sessionUser['id'],
            'start_date': start_date,
            'end_date': end_date,
            'grand_total': totalPrice,
          }),
        );
        Map<String, dynamic> data = response.data;
        if (data['error']) {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: true);

        } else {
          EasyLoading.dismiss();
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['0','ord_asas','tra_dddd','Your_payment_was_declined._Thank_you.'],),));
          SnackBarUtils.show(title: data['message'], isError: false);
        }
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarUtils.show(title: e.toString(), isError: true);
      }

    } else {
      SnackBarUtils.show(title: 'Please Login first', isError: true);
    }
  }

  Future<void> bookRestaurant(restaurantId,userId,totalPrice,numberOfPeople,formattedDateTime,BuildContext context) async {
    final response = await Dio().post(
      URL.bookRestaurantURL,
      data: FormData.fromMap({
        'restaurant_id': restaurantId,
        'user_id': userId,
        'grand_total': totalPrice,
        'num_of_persons': numberOfPeople,
        'start_date': formattedDateTime,
        'end_date': formattedDateTime,
      }),
    );
    Map<String, dynamic> data = response.data;
    if (data['error']) {
      SnackBarUtils.show(
          title: data['message'], isError: true);
    } else {
      EasyLoading.dismiss();
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['0','ord_asas','tra_dddd','Your_payment_was_declined._Thank_you.'],),));

      SnackBarUtils.show(
          title: data['message'], isError: false);
    }
  }

  Future<void> bookActivity(activityId,json,userId,totalPrice,formattedDateTime,BuildContext context) async {
    final json1 = jsonEncode(json);
    print('Activity booking');

    final response = await Dio().post(
      URL.bookActivityURL,
      data: FormData.fromMap({
        'activity_id': activityId,
        'category_id': json1,
        'user_id': userId,
        'grand_total': totalPrice,
        'start_date': formattedDateTime,
        'end_date': formattedDateTime,
      }),
    );
    Map<String, dynamic> data = response.data;
    if (data['error']) {
      SnackBarUtils.show(
          title: data['message'], isError: true);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['0','ord_asas','tra_dddd','Your_payment_was_declined._Thank_you.'],),));

      SnackBarUtils.show(
          title: data['message'], isError: false);
    }
  }

  void bookRoom(totalPrice, start_date, end_date,BuildContext context) async {
    Map sessionUser = await Session().user();
    bool isLogin = await Session().isLogin();
    if (isLogin) {
      EasyLoading.show();
      try {
        final response = await Dio().post(
          URL.bookHotelURL,
          data: FormData.fromMap({
            'hotel_id': Get.parameters['hotel_id'],
            'room_id': Get.parameters['id'],
            'user_id': sessionUser['id'],
            'start_date': start_date,
            'end_date': end_date,
            'grand_total': totalPrice,
          }),
        );
        Map<String, dynamic> data = response.data;
        if (data['error']) {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: true);
        } else {
          EasyLoading.dismiss();
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['0','ord_asas','tra_dddd','Your_payment_was_declined._Thank_you.'],),));

          SnackBarUtils.show(title: data['message'], isError: false);
        }
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarUtils.show(title: e.toString(), isError: true);
      }
      // setState(() {
      //   _rangeStart = _rangeEnd = null;
      //   _selectedEvents.value = _getEventsForDay(_focusedDay);
      // });
    } else {
      SnackBarUtils.show(title: 'Please Login first', isError: true);
    }
  }
}