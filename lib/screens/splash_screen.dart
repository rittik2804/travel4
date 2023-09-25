import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/screens/error_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

String checkPointMessage = "";

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // splash animation
  late final AnimationController _lottieController =
      AnimationController(vsync: this);

    @override
  void initState() {
    checkpoint();
    super.initState();
  }


  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  checkpoint() async {
    DateTime datetime = await getServerDateTime();
    if (datetime.isBefore(DateTime.now())) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ErrorMessage()),
        (Route<dynamic> route) => false,
      );
    }else{
      Future.delayed(Duration(seconds: 1), () async {
      Get.offAllNamed('/home');
    });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/json/splash.json',
                  width: 400,
                  repeat: false,
                  controller: _lottieController,
                  onLoaded: (composition) {
                    _lottieController
                      ..duration = composition.duration
                      ..forward().whenComplete(() async {
                      
                      });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
