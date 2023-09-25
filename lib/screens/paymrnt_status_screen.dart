
import 'package:flutter/material.dart';


class PaymentStatusScreen extends StatefulWidget {
  final List paymentData;
  const PaymentStatusScreen({Key? key, required this.paymentData})
      : super(key: key);

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.paymentData);
    return Scaffold(
      body: widget.paymentData[0] == '0'
          ? Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,size: 100,
                  ),
                  Text('oops!',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                  Text('Payment failed',style: TextStyle(fontSize: 26),),
                  SizedBox(height: 20,),
                  Container(padding: EdgeInsets.symmetric(horizontal: 50),child: Text('Message: ${widget.paymentData[3]}',style: TextStyle(fontSize: 18),)),
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('Try Again')),
                  )
                ],
              ),
          )
          : Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.gpp_good,
                    color: Colors.green,size: 100,
                  ),
                  SizedBox(height: 20,),
                  Text('Congratulation!',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                  Text('Payment Successful',style: TextStyle(fontSize: 26),),
                  SizedBox(height: 40,),
                  Text('Your Order placed',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text('Order Id # ${widget.paymentData[1]}',style: TextStyle(fontSize: 16),),
                  Text('Transaction Id #${widget.paymentData[2]}',style: TextStyle(fontSize: 16),),
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('Continue Shopping')),
                  )
                ],
              ),
          ),
    );
  }
}
