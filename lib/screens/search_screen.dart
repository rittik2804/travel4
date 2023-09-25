import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now().add(Duration(days: 7));
  String label1 = Get.parameters['name'].toString() == 'Hotels'
      ? 'Check-in'
      : 'Depart Date';
  String label2 = Get.parameters['name'].toString() == 'Hotels'
      ? 'Check-out'
      : 'Return Date';
  String route =
      Get.parameters['name'].toString() == 'Hotels' ? 'hotel' : 'car';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.defaultSize),
          child: ListView(
            children: [
              Text(
                label1,
              ),
              GestureDetector(
                onTap: () {
                  showCheckIn(context);
                },
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.defaultSize,
                    vertical: Dimensions.smSize,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: Dimensions.defaultSize,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: RGB.border,
                    ),
                    borderRadius: BorderRadius.circular(
                      Dimensions.defaultSize / 2,
                    ),
                  ),
                  child: Text(
                    DateFormat.yMMMMd("en_US").format(checkIn).toString(),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.defaultSize / 2),
              Text(
                label2,
              ),
              GestureDetector(
                onTap: () {
                  showCheckOut(context);
                },
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.defaultSize,
                    vertical: Dimensions.smSize,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: Dimensions.defaultSize,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: RGB.border,
                    ),
                    borderRadius: BorderRadius.circular(
                      Dimensions.defaultSize / 2,
                    ),
                  ),
                  child: Text(
                    DateFormat.yMMMMd("en_US").format(checkOut).toString(),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.defaultSize / 2),
              ElevatedButton(
                onPressed: () {
                  EasyLoading.show();
                  Future.delayed(const Duration(seconds: 1), () {
                    EasyLoading.dismiss();
                    Get.toNamed('/$route');
                  });
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showCheckIn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: checkIn,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (picked != null) {
      setState(() {
        checkIn = picked;
      });
    }
  }

  Future showCheckOut(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: checkOut,
        currentDate: checkOut,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (picked != null && picked.isAfter(checkIn)) {
      setState(() {
        checkOut = picked;
      });
    } else if (picked != null && picked.isBefore(checkIn)) {
      SnackBarUtils.show(
        title:
            '${Get.parameters['name'].toString() == "Hotels" ? "Check-Out" : "Return Date"} date cannot be before the ${Get.parameters['name'].toString() == "Hotels" ? "Check-In" : "Depart Date"} date',
        isError: true,
      );
    }
  }
}
