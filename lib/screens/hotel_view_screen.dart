import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:travel/widget/app_widget.dart';

class HotelViewScreen extends StatefulWidget {
  const HotelViewScreen({super.key});

  @override
  State<HotelViewScreen> createState() => _HotelViewScreenState();
}

class _HotelViewScreenState extends State<HotelViewScreen> {
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
        title: const Text('Hotels'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          color: RGB.grey.withOpacity(0.25),
          child: isLoaded
              ? dataList.isNotEmpty
                  ? ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        List<String> photoList =
                            dataList[index]['photo'].split(',');
                        List<String> updatedPhotoList = [];

                        for (String photo in photoList) {
                          updatedPhotoList.add('${URL.photoURL}hotels/$photo');
                        }

                        String photos = updatedPhotoList.join(',');

                        return AppWidget.hotelListView(
                          id: dataList[index]['hotel_id'],
                          picture:
                              '${URL.photoURL}hotels/${dataList[index]['photo']}',
                          name: dataList[index]['name'],
                          location: dataList[index]['address'],
                          onPressed: () {
                            Get.toNamed('/hotel_details', parameters: {
                              'hotel_id':
                                  dataList[index]['hotel_id'].toString(),
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
                              'check_out': dataList[index]['checkout_time']
                                      ?.toString() ??
                                  "00:00:00",
                              'rooms': jsonEncode(dataList[index]['rooms']),
                            });
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('No Hotel Found!'),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  // functional task
  void initApp() async {
    // call api part
    try {
      Response response = await Dio().get(
        URL.hotelURL,
      );

      Map<String, dynamic> data = response.data['data'];
      if (response.data['error']) {
        SnackBarUtils.show(title: response.data['message'], isError: true);
      } else {
        dataList = data['hotels'];
        isLoaded = true;
      }
      print(response.data);
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    if (mounted) {
      setState(() {});
    }
  }
}
