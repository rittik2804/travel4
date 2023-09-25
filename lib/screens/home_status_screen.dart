import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/url.dart';
import 'package:travel/data/category_data.dart';
import 'package:travel/screens/senangpay-form-screen.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/screen_size.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../utils/payment_util.dart';



class HomeStatusScreen extends StatefulWidget {
  const HomeStatusScreen({super.key});

  @override
  State<HomeStatusScreen> createState() => _HomeStatusScreenState();
}

class _HomeStatusScreenState extends State<HomeStatusScreen> {
  bool isLoaded = false;
  List? dataList;
  List? dataListActivity;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  String generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_$timestamp';
  }

  // Future<void> makePayment(String details, double ammount,String order_Id, String nameU, String emailU, String phoneU,BuildContext context) async {
  //   try {
  //     // 1. Set the payment details
  //     String merchantId = '827169018481024';
  //     String secretKey = '39853-2042292850';
  //     String detail = details;
  //     double amount = ammount;
  //     String orderId = order_Id;
  //     String name = nameU;
  //     String email = emailU;
  //     String phone = phoneU;
  //
  //     // 2. Calculate the hash (You may need to implement your hash generation logic)
  //     String hash = generateSecureHash(secretKey, detail, amount, orderId);
  //     print(hash);
  //     print(verifySecureHash(hash, secretKey, detail, amount, orderId));
  //     // 3. Create the payment request data
  //     Map<String, dynamic> paymentData = {
  //       'detail': detail,
  //       'amount': amount.toStringAsFixed(2),
  //       'order_id': orderId,
  //       'hash': hash,
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //     };
  //
  //     // 4. Send a POST request to the SenangPay API
  //     String paymentUrl = 'https://app.senangpay.my/payment/$merchantId';
  //     final response =
  //         await http.post(Uri.parse(paymentUrl), body: paymentData);
  //
  //     if (response.statusCode == 200) {
  //       print('Payment initiated successfully');
  //       String responseBody = response.body;
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => SenangPayFormScreen(htmlForm: responseBody,),));
  //
  //     } else {
  //       // 6. Handle errors or failures
  //       print('Payment initiation failed. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     // 7. Handle exceptions
  //     print('An error occurred during payment initiation: $e');
  //   }
  // }

  bool verifySecureHash(String receivedHash, String secretKey, String detail,
      double amount, String orderId) {
    // Generate the expected hash using the same method as above
    String expectedHash =
        generateSecureHash(secretKey, detail, amount, orderId);

    // Compare the received hash with the expected hash
    return receivedHash == expectedHash;
  }

  String generateSecureHash(
      String secretKey, String detail, double amount, String orderId) {
    // Concatenate the parameters into a single string
    String combinedString =
        '$secretKey$detail${amount.toStringAsFixed(2)}$orderId';

    // Convert the combined string to bytes
    Uint8List bytes = Uint8List.fromList(utf8.encode(combinedString));

    // Use HMAC-SHA256 for hash generation
    Hmac hmac = Hmac(sha256, utf8.encode(secretKey)); // or use md5 as needed
    Digest digest = hmac.convert(bytes);

    // Return the hash as a hexadecimal string
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.defaultSize,
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryData.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        categoryData[index].routeName,
                        parameters: {
                          'name': categoryData[index].name,
                        },
                      );
                    },
                    child: Container(
                      width: 90,
                      margin: EdgeInsets.only(
                        right: index == categoryData.length - 1
                            ? Dimensions.zeroSize
                            : Dimensions.smSize / 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              Dimensions.smSize,
                            ),
                            decoration: BoxDecoration(
                              color: RGB.primary,
                              borderRadius: BorderRadius.circular(
                                Dimensions.circleSize,
                              ),
                            ),
                            child: Icon(
                              categoryData[index].icon,
                              color: RGB.white,
                              size: Dimensions.defaultSize * 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize / 4,
                          ),
                          Text(
                            categoryData[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: Dimensions.smSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const Text('Recommended For You'),
          const Text(
            'Based on your recent activity',
            style: TextStyle(
              fontSize: Dimensions.smSize,
              color: RGB.lightDarker,
            ),
          ),
          const SizedBox(
            height: Dimensions.defaultSize,
          ),
          isLoaded == true && dataList != null && dataList!.length > 0
              ? ResponsiveHelper.isMobile(context)
                  ? SizedBox(
                      height: 320,
                      width: Get.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: dataList!.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              goToHotel(dataList, index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: Dimensions.defaultSize,
                              ),
                              width: Get.width / 1.75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.defaultSize,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${URL.photoURL}hotels/${dataList![index]['photo'].split(',')[0]}',
                                      height: 210,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/loading.jpg',
                                        height: 210,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/loading.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.smSize / 2,
                                  ),
                                  Text(
                                    dataList![index]['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: Dimensions.lgSize,
                                      color: RGB.lightDarker,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        UniconsLine.location_point,
                                        color: RGB.lightDarker,
                                        size: Dimensions.defaultSize,
                                      ),
                                      Expanded(
                                        child: Text(
                                          dataList![index]['address'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: Dimensions.smSize,
                                            color: RGB.lightDarker,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, //number of columns
                        childAspectRatio: 1.75 / 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      shrinkWrap: true,
                      children: List.generate(
                        dataList!.length,
                        (index) => GestureDetector(
                          onTap: () {
                            goToHotel(dataList, index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: Dimensions.defaultSize),
                            // height: 450,
                            // width: Get.width / 1.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.defaultSize),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${URL.photoURL}hotels/${dataList![index]['photo'].split(',')[0]}',
                                    height: 210,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/loading.jpg',
                                      height: 210,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/loading.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.smSize / 2),
                                Text(
                                  dataList![index]['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: Dimensions.lgSize,
                                    color: RGB.lightDarker,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      UniconsLine.location_point,
                                      color: RGB.lightDarker,
                                      size: Dimensions.defaultSize,
                                    ),
                                    Expanded(
                                      child: Text(
                                        dataList![index]['address'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: Dimensions.smSize,
                                          color: RGB.lightDarker,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              : dataList != null && dataList!.length == 0
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          isLoaded = false;
                          dataList = null;
                          setState(() {});
                          initApp();
                        },
                        child: Text("Retry"),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
          isLoaded == true &&
                  dataListActivity != null &&
                  dataListActivity!.length > 0
              ? ResponsiveHelper.isMobile(context)
                  ? SizedBox(
                      height: 320,
                      width: Get.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: dataListActivity!.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                               'activity',

                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: Dimensions.defaultSize,
                              ),
                              width: Get.width / 1.75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.defaultSize,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${URL.photoURL}activities/${dataListActivity![index]['photo'].split(',')[0]}',
                                      height: 210,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/loading.jpg',
                                        height: 210,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/loading.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.smSize / 2,
                                  ),
                                  Text(
                                    dataListActivity![index]['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: Dimensions.lgSize,
                                      color: RGB.lightDarker,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        UniconsLine.location_point,
                                        color: RGB.lightDarker,
                                        size: Dimensions.defaultSize,
                                      ),
                                      Expanded(
                                        child: Text(
                                          dataListActivity![index]
                                              ['description'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: Dimensions.smSize,
                                            color: RGB.lightDarker,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, //number of columns
                        childAspectRatio: 1.75 / 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      shrinkWrap: true,
                      children: List.generate(
                        dataListActivity!.length,
                        (index) => GestureDetector(
                          onTap: () {
                            goToHotel(dataListActivity, index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: Dimensions.defaultSize),
                            // height: 450,
                            // width: Get.width / 1.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.defaultSize),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${URL.photoURL}activities/${dataListActivity![index]['photo'].split(',')[0]}',
                                    height: 210,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/loading.jpg',
                                      height: 210,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/loading.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.smSize / 2),
                                Text(
                                  dataListActivity![index]['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: Dimensions.lgSize,
                                    color: RGB.lightDarker,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      UniconsLine.location_point,
                                      color: RGB.lightDarker,
                                      size: Dimensions.defaultSize,
                                    ),
                                    Expanded(
                                      child: Text(
                                        dataList![index]['description'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: Dimensions.smSize,
                                          color: RGB.lightDarker,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              : dataList != null && dataList!.length == 0
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          isLoaded = false;
                          dataList = null;
                          setState(() {});
                          initApp();
                        },
                        child: Text("Retry"),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),

        ],
      ),
    );
  }

  goToHotel(dataList, index) {
    List<String> photoList = dataList![index]['photo'].split(',');
    List<String> updatedPhotoList = [];

    for (String photo in photoList) {
      updatedPhotoList.add('${URL.photoURL}hotels/$photo');
    }

    String photos = updatedPhotoList.join(',');
    if (dataList != null) {
      Get.toNamed('/hotel_details', parameters: {
        'hotel_id': dataList![index]['hotel_id'].toString(),
        'name': dataList![index]['name'].toString(),
        'location': dataList![index]['address'].toString(),
        'description': dataList![index]['description'].toString(),
        'picture': photos,
        'price': dataList![index]['price'].toString(),
        'wifi': dataList![index]['wifi'].toString(),
        'pool': dataList![index]['pool'].toString(),
        'restaurant': dataList![index]['restaurant'].toString(),
        'bar': dataList![index]['bar'].toString(),
        'parking': dataList![index]['parking'].toString(),
        'check_in': dataList![index]['checkin_time']?.toString() ?? "00:00:00",
        'check_out':
            dataList![index]['checkout_time']?.toString() ?? "00:00:00",
        'rooms': jsonEncode(dataList![index]['rooms']),
      });
    }
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
      print(dataList!.length);
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }

    try {
      Response response = await Dio().get(
        URL.activityURL,
      );
      Map data = response.data;
      print(data.toString());
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataListActivity = data['data']['activities'];
        isLoaded = true;
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    print(dataListActivity![0]);
    if (mounted) {
      setState(() {});
    }
  }
}
