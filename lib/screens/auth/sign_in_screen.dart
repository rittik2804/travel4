import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/forms_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/screen_size.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // form
  final _formKeyLogin = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // password visibility
  bool passwordVisibility = true;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.lgSize * 2,
              horizontal: Dimensions.defaultSize,
            ),
            width: kIsWeb
                ? !ResponsiveHelper.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 1
                : null,
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                    bottom: Dimensions.lgSize,
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                  ),
                ),
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.defaultSize * 1.5,
                    fontWeight: FontWeight.w700,
                    color: RGB.dark,
                  ),
                ),
                const SizedBox(
                  height: Dimensions.lgSize,
                ),
                Form(
                  key: _formKeyLogin,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.emailAddress,
                          validator: RequiredValidator(
                              errorText: 'Email is required!'),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Email',
                          ),
                          cursorColor: RGB.dark,
                        ),
                        const SizedBox(height: Dimensions.lgSize),
                        TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisibility,
                          keyboardType: TextInputType.text,
                          validator: RequiredValidator(
                              errorText: 'Password is required!'),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Password',
                            suffixIcon: UniconsLine.eye,
                            passwordVisibility: passwordVisibility,
                            suffixOnPressed: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          ),
                          cursorColor: RGB.dark,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: forgotPassword,
                                child: Text("Forgot Password?"))
                          ],
                        ),
                        // const SizedBox(height: Dimensions.lgSize),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final form = _formKeyLogin.currentState;
                            if (form!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              form.save();
                              // call api part
                              var formData = {
                                'email': userNameController.text,
                                'password': passwordController.text,
                              };

                              try {
                                var response = await http.post(
                                  Uri.parse(URL.loginURL),
                                  body: formData,
                                );
                                print(response.statusCode);
                                var responseData = jsonDecode(response.body);

                                if (responseData['error']) {

                                  SnackBarUtils.show(
                                      title: responseData['message'],
                                      isError: true);
                                } else {

                                  Map<String, dynamic> userData =
                                      responseData['user'];
                                  await Session().userSave(userData);
                                  SnackBarUtils.show(
                                      title: 'Login success', isError: false);
                                  Get.offAllNamed('/home');
                                }

                                // Response response = await Dio().post(
                                //     URL.loginURL,
                                //     data: formData,
                                //     );

                                // Instead of: Map<String, dynamic> userData = jsonDecode(response.data);
                                // Check for errors
                                // if (response.data['error']) {
                                //   SnackBarUtils.show(
                                //       title: response.data['message'],
                                //       isError: true);
                                // } else {
                                //   Map<String, dynamic> userData =
                                //       response.data['user'];

                                //   await Session().userSave(userData);
                                //   SnackBarUtils.show(
                                //       title: 'Login success', isError: false);
                                //   Get.offAllNamed('/home');
                                // }
                              } catch (e) {
                                SnackBarUtils.show(
                                    title: e.toString(), isError: true);
                              }
                              EasyLoading.dismiss();
                            }

                            return;
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: const Text(
                              'Continue',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.smSize,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('signup');
                  },
                  child: const Text(
                    'Sign up now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RGB.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.smSize / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void forgotPassword() {
    FocusNode node = new FocusNode();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController _controller = TextEditingController();
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Forgot Password'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _controller,
                        focusNode: node,
                        validator: RequiredValidator(
                            errorText: 'This field is required!'),
                        decoration: FormsUtils.inputStyle(
                          hintText: 'Email Address',
                        ),
                        cursorColor: RGB.dark,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_controller.text.trim().isEmpty) {
                        SnackBarUtils.show(
                            title: 'Email field cannot be empty',
                            isError: true);
                        return;
                      }

                      EasyLoading.show();
                      node.unfocus();
                      try {
                        Response response = await Dio().post(
                          URL.forgotPasswordURL,
                          data: FormData.fromMap({
                            'email': _controller.text.trim(),
                          }),
                        );
                        Map<String, dynamic> data = response.data;
                        if (data['error']) {
                          EasyLoading.dismiss();
                          SnackBarUtils.show(
                              title: data['message'], isError: true);
                        } else {
                          EasyLoading.dismiss();
                          // SnackBarUtils.show(
                          //     title: data['message'], isError: false);
                          Navigator.of(context).pop();

                          showSuccess();
                        }
                      } catch (e) {
                        SnackBarUtils.show(title: e.toString(), isError: true);
                        EasyLoading.dismiss();
                      }
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  void showSuccess() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'An email is sent to your email address with a link. Use it to change your password. It will expires in 15 minutes.',
                  style: TextStyle(color: Colors.green.shade400),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        });
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!oldValue.text.contains("(") &&
        oldValue.text.length >= 10 &&
        newValue.text.length != oldValue.text.length) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (oldValue.text.length > newValue.text.length) {
      return TextEditingValue(
        text: newValue.text.toString(),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }

    var newText = newValue.text;
    if (newText.length == 1) newText = "($newText";
    if (newText.length == 4) newText = "$newText) ";
    if (newText.length == 9) newText = "$newText ";

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
