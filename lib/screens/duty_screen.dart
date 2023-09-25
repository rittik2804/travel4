import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/models/cart_model.dart';
import 'package:travel/screens/cart/cart_screen.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';

import '../widget/hotel_room.dart';
import '../widget/images_carousel.dart';

class DutyScreen extends StatefulWidget {
  const DutyScreen({super.key});

  @override
  State<DutyScreen> createState() => _DutyScreenState();
}

late Cart _cart;
String data ='';


class _DutyScreenState extends State<DutyScreen> {
  bool isLoaded = false;
  List dataList = [];
int totalItems = 0;
  @override
  void initState() {
    loadData();
    super.initState();
    initApp();
  }
  Future<void> loadData() async {

    final loadedCart = await CartStorage.getCart();
    print('Loaded Cart: $loadedCart');
    Map sessionUser = await Session().user();
    data = sessionUser['id'];
    _cart = Cart(userId: sessionUser['id'], items: loadedCart);
    setState(() {
    });
  }
  Future<List> loadCartItems() async {
    final roomsData = jsonDecode(Get.parameters['rooms']!);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString('id');
    final rooms = List<Room>.from(roomsData.map((roomData) => Room(
      id: roomData['id'].toString(),
      hotel_id: Get.parameters['hotel_id'].toString(),
      title: roomData['name'].toString(),
      imageUrl: '${roomData['picture']}'.toString(),
      bedType: roomData['bed_type'].toString(),
      room_size: roomData['room_size'].toString(),
      persons_allowed: roomData['persons_allowed'].toString(),
      breakfast: roomData['breakfast'].toString(),
    ))).removeWhere((element) => element.id != id);
    return roomsData;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        title: const Text('Duty'),
      ),
      body: data.isNotEmpty ? SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          color: RGB.grey.withOpacity(0.25),
          child: isLoaded
              ?
                 dataList.isNotEmpty
                     ? ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    List<String> photoList =
                        dataList[index]['photo'].split(',');
                    List<String> updatedPhotoList = [];

                    for (String photo in photoList) {
                      updatedPhotoList.add('${URL.photoURL}souvenirs/$photo');
                    }

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: Dimensions.lgSize,
                      ),
                      decoration: BoxDecoration(
                        color: RGB.white,
                        border: Border.all(
                          width: 1,
                          color: RGB.lightPrimary,
                        ),
                        borderRadius: BorderRadius.circular(
                          Dimensions.defaultSize,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImagesCarousel(
                            photos: updatedPhotoList,
                            isTrue: true,
                          ),
                          // Center(
                          //   child: Container(
                          //     width: Get.width / 1.5,
                          //     alignment: Alignment.center,
                          //     padding: const EdgeInsets.only(
                          //       top: Dimensions.smSize,
                          //     ),
                          //     child: ClipRRect(
                          //       borderRadius: const BorderRadius.only(
                          //         topLeft: Radius.circular(
                          //           Dimensions.defaultSize,
                          //         ),
                          //         topRight: Radius.circular(
                          //           Dimensions.defaultSize,
                          //         ),
                          //       ),
                          //       child: CachedNetworkImage(
                          //         imageUrl: URL.photoURL +
                          //             'souvenirs/' +
                          //             dataList[index]['photo'].split(',')[0],
                          //         fit: BoxFit.cover,
                          //         width: Get.width,
                          //         height: 200,
                          //         placeholder: (context, url) => Image.asset(
                          //           'assets/images/loading.jpg',
                          //           fit: BoxFit.cover,
                          //           width: Get.width,
                          //         ),
                          //         errorWidget: (context, url, error) =>
                          //             Image.asset(
                          //           'assets/images/loading.jpg',
                          //           fit: BoxFit.cover,
                          //           width: Get.width,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Text(
                              dataList[index]['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: Dimensions.defaultSize,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Text(
                              dataList[index]['description'],
                              style: const TextStyle(
                                fontSize: Dimensions.smSize,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dataList[index]['price'] + 'RM',
                                  style: const TextStyle(
                                    fontSize: Dimensions.lgSize * 1.25,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final item = CartItem(
                                      dutyId: dataList[index]['id'],
                                      name: dataList[index]['name'],
                                      photo: dataList[index]['photo']
                                          .toString()
                                          .split(',')[0],
                                      price: double.parse(
                                          dataList[index]['price']),
                                      quantity: 1,
                                    );
                                    _cart.addItem(item);

                                    setState(() {});

                                    // bookDuty(dataList[index]['id'], dataList[index]['price']);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.lgSize,
                                    ),
                                    child: Text('Add to Cart'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                        ],
                      ),
                    );
                  },
                ) : Center(child: Text('No duty found!'))
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ) : Center(child: Text('Please login first!')),
      floatingActionButton: data.isNotEmpty  ? FloatingActionButton.extended(
        onPressed: () async {
          Map sessionUser = await Session().user();
          bool isLogin = await Session().isLogin();
          if (isLogin) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(
                  userId: sessionUser['id'],
                  cart: _cart,
                  onUpdate: updateCart,
                ),
              ),
            );
          } else {
            Get.toNamed('/signin');
          }
        },
        label: Text('Cart (${_cart.totalItems})'),
        icon: Stack(
          children: [
            Icon(Icons.shopping_cart),
            if (_cart.totalItems > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${_cart.totalItems}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
      ) : SizedBox(),
    );
  }


  void updateCart() {
    setState(() {});
  }

  void bookDuty(dutyId, totalPrice) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          DateTime _selectedDate = DateTime.now();
          TimeOfDay _selectedTime = TimeOfDay.now();

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Enter Details'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _selectedDate)
                              setState(() {
                                _selectedDate = picked;
                              });
                          },
                          child: Text('Select Date'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Time: ${_selectedTime.format(context)}'),
                        TextButton(
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null && picked != _selectedTime)
                              setState(() {
                                _selectedTime = picked;
                              });
                          },
                          child: Text('Select Time'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Price: $totalPrice'),
                  ],
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
                      Navigator.pop(context);
                      DateTime selectedDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      String formattedDateTime =
                          selectedDateTime.toUtc().toIso8601String();

                      Map sessionUser = await Session().user();
                      bool isLogin = await Session().isLogin();
                      if (isLogin) {
                        EasyLoading.show();
                        // call api part
                        try {
                          Response response = await Dio().post(
                            URL.bookDutyURL,
                            data: FormData.fromMap({
                              'duty_id': dutyId,
                              'user_id': sessionUser['id'],
                              'grand_total': totalPrice,
                              'start_date': formattedDateTime,
                              'end_date': formattedDateTime,
                            }),
                          );
                          Map<String, dynamic> data = response.data;
                          if (data['error']) {
                            EasyLoading.dismiss();
                            SnackBarUtils.show(
                                title: data['message'], isError: true);
                          } else {
                            EasyLoading.dismiss();
                            SnackBarUtils.show(
                                title: data['message'], isError: false);
                          }
                        } catch (e) {
                          SnackBarUtils.show(
                              title: e.toString(), isError: true);
                          EasyLoading.dismiss();
                        }
                      } else {
                        Get.toNamed('/signin');
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Book',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  // functional task
  void initApp() async {
    // call api part
    try {
      Response response = await Dio().get(
        URL.dutyURL,
      );
      Map data = response.data;
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataList = data['data']['duty'];
        isLoaded = true;
        print(dataList);

      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    setState(() {});
  }
}
