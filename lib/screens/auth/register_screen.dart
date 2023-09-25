import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/forms_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

import '../../utils/screen_size.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  // password visibility
  bool passwordVisibility = true;
  // gender
  String selectedGender = 'male';
  // date of birth
  bool isDatePicked = false;
  DateTime dateOfBirth = DateTime.now();
  // country code picked
  bool countryCodePicked = false;
  String dialCode = '';

  @override
  void dispose() {
    nameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: kIsWeb
            ? !ResponsiveHelper.isMobile(context)
                ? true
                : false
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(
              Dimensions.defaultSize,
            ),
            width: kIsWeb
                ? !ResponsiveHelper.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 1
                : null,
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    validator:
                        RequiredValidator(errorText: 'This field is required!'),
                    decoration: FormsUtils.inputStyle(
                      hintText: 'Name',
                    ),
                    cursorColor: RGB.dark,
                  ),
                  const SizedBox(height: Dimensions.lgSize),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator:
                        RequiredValidator(errorText: 'This field is required!'),
                    decoration: FormsUtils.inputStyle(
                      hintText: 'Email',
                    ),
                    cursorColor: RGB.dark,
                  ),
                  const SizedBox(height: Dimensions.lgSize),
                  TextFormField(
                    obscureText: passwordVisibility,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    validator:
                        RequiredValidator(errorText: 'This field is required!'),
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
                  const SizedBox(height: Dimensions.lgSize),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: mobileController,
                    validator:
                        RequiredValidator(errorText: 'This field is required!'),
                    decoration: FormsUtils.inputStyle(
                      hintText: 'Mobile number',
                    ),
                    cursorColor: RGB.dark,
                  ),
                  const SizedBox(height: Dimensions.lgSize),
                  const SizedBox(height: Dimensions.lgSize),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        EasyLoading.show(status: 'loading...');
                        form.save();
                        // call api part
                        FormData formData = FormData.fromMap({
                          'name': nameController.text,
                          'email': emailController.text.trim(),
                          'phone': mobileController.text,
                          'password': passwordController.text,
                        });
                        try {
                          Response response = await Dio().post(
                            URL.signUpURL,
                            data: formData,
                          );
                          print(response.data);
                          if (response.data['error']) {
                            SnackBarUtils.show(
                                title: response.data['message'], isError: true);
                          } else {
                            Map<String, dynamic> userData =
                                response.data['users'];
                            print(response.data);
                            await Session().userSave(userData);
                            SnackBarUtils.show(
                                title: 'Registration success', isError: false);
                            Get.offAllNamed('/home');
                          }
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
        ),
      ),
    );
  }

  Future dateOfBirthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
        isDatePicked = true;
      });
    }
  }
}
