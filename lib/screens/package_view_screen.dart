
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:travel/widget/app_widget.dart';

class PackageViewScreen extends StatefulWidget {
  const PackageViewScreen({super.key});

  @override
  State<PackageViewScreen> createState() => _PackageViewScreenState();
}

class _PackageViewScreenState extends State<PackageViewScreen> {
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
        title: const Text('Packages'),
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
                      updatedPhotoList.add('${URL.photoURL}packages/$photo');
                    }

                    String photos = updatedPhotoList.join(',');
                    return AppWidget.packageListView(
                      id: dataList[index]['package_id'],
                      picture: photos,
                      name: dataList[index]['name'],
                      location: dataList[index]['description'],
                      offer: '10% OFF',
                      price: dataList[index]['price'],
                      days: dataList[index]['days'].toString(),
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
        URL.packageURL,
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
