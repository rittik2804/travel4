import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../config/url.dart';
import '../utils/dimensions_utils.dart';
import '../utils/rgb_utils.dart';
import '../utils/snackbar__utils.dart';
import '../widget/app_widget.dart';

class HomeStayScreen extends StatefulWidget {
  const HomeStayScreen({Key? key}) : super(key: key);

  @override
  State<HomeStayScreen> createState() => _HomeStayScreenState();
}

class _HomeStayScreenState extends State<HomeStayScreen> {
  bool isLoaded = false;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    initApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        title: const Text('Home Stay'),
      ),
      body: SafeArea(
        child: isLoaded ? Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          color: RGB.grey.withOpacity(0.25),
          child: dataList.isNotEmpty
              ? ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              List<String> photoList =
              dataList[index]['photo'].split(',');
              List<String> updatedPhotoList = [];

              for (String photo in photoList) {
                updatedPhotoList.add('${URL.photoURL}homestays/$photo');
              }

              String photos = updatedPhotoList.join(',');

              return AppWidget.hotelListView(
                id: dataList[index]['homestay_id'],
                picture:
                '$photos',
                name: dataList[index]['name'],
                location: dataList[index]['address'],
                onPressed: () {
                  Get.toNamed('/homestay_detail', parameters: {
                    'homestay_id': dataList[index]['homestay_id'].toString(),
                    'name': dataList[index]['name'].toString(),
                    'location': dataList[index]['address'].toString(),
                    'description':
                    dataList[index]['description'].toString(),
                    'picture': photos,
                    'price': dataList[index]['price'].toString(),
                    'wifi': dataList[index]['wifi'].toString(),
                    'pool': dataList[index]['pool'].toString(),
                    'restaurant':
                    dataList[index]['restaurant'].toString(),
                    'bar': dataList[index]['bar'].toString(),
                    'parking': dataList[index]['parking'].toString(),
                    'check_in':
                    dataList[index]['checkin_time']?.toString() ??
                        "00:00:00",
                    'check_out':
                    dataList[index]['checkout_time']?.toString() ??
                        "00:00:00",
                    'rooms': jsonEncode(dataList[index]['rooms']),
                  });
                },
              );
            },
          )
              : const Center(
            child: Text('No Home Stay found!'),
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
  void initApp() async {
    // call api part
    try {
      Response response = await Dio().get(
        URL.homestayURL,
      );
      Map<String, dynamic> data = response.data['data'];
      if (response.data['error']) {
        SnackBarUtils.show(title: response.data['message'], isError: true);
      } else {
        dataList = data['homestays'];
        print(dataList);
        isLoaded = true;
      }
      print(data);
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    if (mounted) {
      setState(() {});
    }
  }
}
