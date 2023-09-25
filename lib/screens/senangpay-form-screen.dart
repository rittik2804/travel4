import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:travel/screens/paymrnt_status_screen.dart';
import 'package:travel/utils/payment_util.dart';


class SenangPayFormScreen extends StatefulWidget {
  List data;
  final String htmlForm;
  String type;
  SenangPayFormScreen({required this.htmlForm,required this.data,required this.type});

  @override
  _SenangPayFormScreenState createState() => _SenangPayFormScreenState();
}

class _SenangPayFormScreenState extends State<SenangPayFormScreen> {
  late InAppWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SenangPay Payment Form'),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: widget.htmlForm,
          baseUrl: Uri.parse('https://app.senangpay.my/payment/827169018481024'),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) async {
          // switch(widget.type){
          //   case 'hotel':
          //     //Booking().book(widget.data[0], widget.data[1], widget.data[3],context);
          //     break;
          //   case 'car':
          //     Booking().bookCar(widget.data[0], widget.data[1], widget.data[2],context);
          //     break;
          //   case 'package':
          //     //Booking().book(widget.data[0], widget.data[1], widget.data[3],context);
          //     break;
          //   case 'restaurant':
          //   Booking().bookRestaurant(widget.data[0],widget.data[1] ,widget.data[2] ,widget.data[3] , widget.data[4],context);
          //     break;
          //   case 'activity':
          //     Booking().bookActivity(widget.data[0],widget.data[1] ,widget.data[2] ,widget.data[3] , widget.data[4],context);
          //     break;
          //   case 'room':
          //     Booking().bookRoom(widget.data[0],widget.data[1] ,widget.data[2],context);
          //     break;
          // }
          this.controller = controller;
        },
        onConsoleMessage: (controller, consoleMessage) async {
          print('onConsole');
          var data = await controller.getUrl();
          print('data $data');
          print('original ${await controller.getOriginalUrl()}');

          // Check for the 'PaymentCompleted' message from JavaScript
          if ( data.toString() != 'about:blank') {
            print('object');

            // The payment is completed, trigger the checkPayment method or logic
            final status = checkPayment(data.toString(),'status_id');
            final orderId = checkPayment(data.toString(),'order_id');
            final transactionId = checkPayment(data.toString(),'transaction_id');
            final msg = checkPayment(data.toString(),'msg');
            List paymentData = [];
            paymentData.add(status);
            paymentData.add(orderId);
            paymentData.add(transactionId);
            paymentData.add(msg);

            // Navigator.pop(context);
            print(msg);
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: paymentData,),));

          }
        },
      ),
    );
  }

  String checkPayment(String data, String key) {
    final splitData = data.split('&');

    for(int i=0; i<splitData.length; i++){
      var pair = splitData[i].split('=');
      if(pair[0] == key)
        return pair[1];
    }
    return '';
  }
}
