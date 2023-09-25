// ignore: file_names
// ignore: file_names
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:get/get.dart' hide Response, FormData, MultipartFile;
// import 'package:intl/intl.dart';
// import 'package:travel/config/session.dart';
// import 'package:travel/config/url.dart';
// import 'package:travel/utils/custom_style_utils.dart';
// import 'package:travel/utils/dimensions_utils.dart';
// import 'package:travel/utils/forms_utils.dart';
// import 'package:travel/utils/rgb_utils.dart';
// import 'package:travel/utils/snackbar__utils.dart';
// import 'package:unicons/unicons.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController surNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   // password visibility
//   bool passwordVisibility = true;
//   // gender
//   String selectedGender = 'male';
//   // date of birth
//   bool isDatePicked = false;
//   DateTime dateOfBirth = DateTime.now();
//   // country code picked
//   bool countryCodePicked = false;
//   String dialCode = '';

//   @override
//   void dispose() {
//     nameController.dispose();
//     surNameController.dispose();
//     emailController.dispose();
//     phoneNumberController.dispose();
//     passwordController.dispose();
//     mobileController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: RGB.white,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(
//             Dimensions.defaultSize,
//           ),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 100,
//                       child: Transform.translate(
//                         offset: const Offset(-8, 0),
//                         child: RadioListTile(
//                           isThreeLine: false,
//                           visualDensity: const VisualDensity(
//                             horizontal: VisualDensity.minimumDensity,
//                             vertical: VisualDensity.minimumDensity,
//                           ),
//                           dense: true,
//                           contentPadding: EdgeInsets.zero,
//                           title: Transform.translate(
//                             offset: const Offset(-8, 0),
//                             child: const Text(
//                               "Male",
//                               style: TextStyle(
//                                 fontSize: Dimensions.defaultSize,
//                               ),
//                             ),
//                           ),
//                           value: "male",
//                           groupValue: selectedGender,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedGender = value!.toString();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 120,
//                       child: Transform.translate(
//                         offset: const Offset(-8, 0),
//                         child: RadioListTile(
//                           isThreeLine: false,
//                           visualDensity: const VisualDensity(
//                             horizontal: VisualDensity.minimumDensity,
//                             vertical: VisualDensity.minimumDensity,
//                           ),
//                           dense: true,
//                           contentPadding: EdgeInsets.zero,
//                           title: Transform.translate(
//                             offset: const Offset(-8, 0),
//                             child: const Text(
//                               "Female",
//                               style: TextStyle(
//                                 fontSize: Dimensions.defaultSize,
//                               ),
//                             ),
//                           ),
//                           value: "female",
//                           groupValue: selectedGender,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedGender = value!.toString();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: Dimensions.smSize,
//                 ),
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: emailController,
//                   validator: EmailValidator(errorText: 'Enter valid email!'),
//                   decoration: FormsUtils.inputStyle(
//                     hintText: 'Email',
//                   ),
//                   cursorColor: RGB.dark,
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 TextFormField(
//                   obscureText: passwordVisibility,
//                   keyboardType: TextInputType.text,
//                   controller: passwordController,
//                   validator:
//                       RequiredValidator(errorText: 'This field is required!'),
//                   decoration: FormsUtils.inputStyle(
//                     hintText: 'Password',
//                     suffixIcon: UniconsLine.eye,
//                     passwordVisibility: passwordVisibility,
//                     suffixOnPressed: () {
//                       setState(() {
//                         passwordVisibility = !passwordVisibility;
//                       });
//                     },
//                   ),
//                   cursorColor: RGB.dark,
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: nameController,
//                   validator:
//                       RequiredValidator(errorText: 'This field is required!'),
//                   decoration: FormsUtils.inputStyle(
//                     hintText: 'Given name',
//                   ),
//                   cursorColor: RGB.dark,
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: surNameController,
//                   validator:
//                       RequiredValidator(errorText: 'This field is required!'),
//                   decoration: FormsUtils.inputStyle(
//                     hintText: 'Family name/Surname',
//                   ),
//                   cursorColor: RGB.dark,
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                     Dimensions.defaultSize / 2,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       dateOfBirthPicker(context);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(
//                         Dimensions.defaultSize / 1.25,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 0.5,
//                           color: RGB.border,
//                         ),
//                         borderRadius: BorderRadius.circular(
//                           Dimensions.radiusSize,
//                         ),
//                       ),
//                       child: Text(
//                         isDatePicked
//                             ? DateFormat.yMMMMd("en_US")
//                                 .format(dateOfBirth)
//                                 .toString()
//                             : 'Date of birth (DD/MM/YYYY)',
//                         style: CustomStyle.textStyle,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         var result = await Get.toNamed('country_code');
//                         if (result != null) {
//                           dialCode = result.toString();
//                         }
//                         setState(() {});
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(
//                           Dimensions.defaultSize / 1.25,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             width: 0.5,
//                             color: RGB.border,
//                           ),
//                           borderRadius: BorderRadius.circular(
//                             Dimensions.radiusSize,
//                           ),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               dialCode != '' ? dialCode : 'Dialing ',
//                               style: const TextStyle(
//                                 color: RGB.lightDarker,
//                               ),
//                             ),
//                             const Icon(
//                               Icons.expand_more_outlined,
//                               color: RGB.lightDarker,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: Dimensions.smSize / 2,
//                     ),
//                     Expanded(
//                       child: SizedBox(
//                         width: Get.width,
//                         child: TextFormField(
//                           keyboardType: TextInputType.number,
//                           controller: mobileController,
//                           validator: RequiredValidator(
//                               errorText: 'This field is required!'),
//                           decoration: FormsUtils.inputStyle(
//                             hintText: 'Mobile number',
//                           ),
//                           cursorColor: RGB.dark,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: Dimensions.lgSize),
//                 const SizedBox(height: Dimensions.lgSize),
//                 ElevatedButton(
//                   onPressed: () async {
//                     FocusScope.of(context).unfocus();
//                     final form = _formKey.currentState;
//                     if (form!.validate()) {
//                       EasyLoading.show(status: 'loading...');
//                       form.save();
//                       // call api part
//                       FormData formData = FormData.fromMap({
//                         'username': nameController.text.trim(),
//                         'name': surNameController.text,
//                         'mobile': dialCode + mobileController.text,
//                         'password': passwordController.text,
//                       });
//                       try {
//                         Response response = await Dio().post(
//                           URL.signUpURL,
//                           data: formData,
//                         );
//                         Map userData = response.data;
//                         if (userData['error']) {
//                           SnackBarUtils.show(
//                               title: 'Error Occurs', isError: true);
//                         } else {
//                           await Session().userSave(userData['user']);
//                           SnackBarUtils.show(
//                               title: 'Registration success', isError: false);
//                           Get.offAllNamed('/home');
//                         }
//                       } catch (e) {
//                         SnackBarUtils.show(title: e.toString(), isError: true);
//                       }
//                       EasyLoading.dismiss();
//                     }
//                     return;
//                   },
//                   child: SizedBox(
//                     width: Get.width,
//                     child: const Text(
//                       'Continue',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future dateOfBirthPicker(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: dateOfBirth,
//         initialDatePickerMode: DatePickerMode.day,
//         firstDate: DateTime(1950),
//         lastDate: DateTime(2101));
//     if (picked != null) {
//       setState(() {
//         dateOfBirth = picked;
//         isDatePicked = true;
//       });
//     }
//   }
// }
