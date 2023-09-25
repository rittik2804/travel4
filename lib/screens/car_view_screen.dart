import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:travel/widget/app_widget.dart';

class CarViewScreen extends StatefulWidget {
  const CarViewScreen({super.key});

  @override
  State<CarViewScreen> createState() => _CarViewScreenState();
}

class _CarViewScreenState extends State<CarViewScreen> {
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
        title: const Text('Cars'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          color: RGB.grey.withOpacity(0.25),
          child: isLoaded
              ? ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    List<String> photoList =
                        dataList[index]['photo'].split(',');
                    List<String> updatedPhotoList = [];

                    for (String photo in photoList) {
                      updatedPhotoList.add('${URL.photoURL}cars/$photo');
                    }

                    String photos = updatedPhotoList.join(',');

                    return AppWidget.carListView(
                      id: dataList[index]['car_id'],
                      picture: photos,
                      name: dataList[index]['name'],
                      location: dataList[index]['description'],
                      price: dataList[index]['price'],
                      seats: '6',
                      model: dataList[index]['license_plate'],
                      color: 'Blue',
                      available: int.parse(dataList[index]['status']),
                      onPressed: () {},
                    );
                  },
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
        URL.carURL,
      );
      Map<String, dynamic> data = response.data;
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataList = data['data'];
        isLoaded = true;
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    setState(() {});
  }
}
