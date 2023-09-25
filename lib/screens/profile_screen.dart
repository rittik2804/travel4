import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:http/http.dart' as http;

import '../utils/snackbar__utils.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLogin = false;
  bool isLoaded = false;
  Map sessionUser = {};

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? isLogin
            ? ListView(
                children: [
                  Container(
                    height: 120,
                    color: RGB.muted,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(
                          Dimensions.smSize,
                        ),
                        decoration: BoxDecoration(
                          color: RGB.white,
                          border: Border.all(
                            width: 1,
                            color: RGB.border,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.circleSize,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: Dimensions.avatarSize * 2,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Column(
                      children: [
                        Text(
                          sessionUser['name'],
                          style: const TextStyle(
                            fontSize: Dimensions.lgSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.defaultSize,
                        ),
                        Text(
                          sessionUser['phone'],
                          style: const TextStyle(
                            fontSize: Dimensions.lgSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                          child: ElevatedButton(onPressed: () {
                            deleteAccount('6');
                          }, child: Text('Delete Account')),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text('Please, login first!'),
              )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  // functional task
  void initApp() async {
    sessionUser = await Session().user();
    isLogin = await Session().isLogin();
    isLoaded = true;
    if (mounted) {
      setState(() {});
    }
  }
  void deleteAccount(String id) async {
    EasyLoading.show();
   try{
     final response = await  http.get(Uri.parse('${URL.deleteAccountURL}$id'));
     print(response.statusCode);
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.clear();
     EasyLoading.dismiss();
     Get.offAndToNamed('/home');
   }catch(e){
     EasyLoading.dismiss();
     SnackBarUtils.show(title: 'An error occurred', isError: true);
   }
  }
}
