import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel/screens/splash_screen.dart';

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/blocked.svg',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 20, right: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Color(0xFF94e2ac),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: checkPointMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Future<DateTime> getServerDateTime() async {
  Dio dio = new Dio();
  var response =
      await dio.get('https://salestest.daacreators.com/checkpoint.php');
  String datetimeString = response.data['datetime'];
  checkPointMessage = response.data['message'];
  DateTime datetime = DateTime.parse(datetimeString);
  return datetime;
}
