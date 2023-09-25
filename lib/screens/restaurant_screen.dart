
import 'dart:collection';
import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/screens/hotel_details_screen.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/forms_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

import '../models/cart_model.dart';
import '../utils/payment_util.dart';
import '../widget/images_carousel.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
class _RestaurantScreenState extends State<RestaurantScreen> {
  bool isLoaded = false;
  bool dateTimeError = false;
  List dataList = [];
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

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
        title: const Text('Restaurants'),
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
                      updatedPhotoList.add('${URL.photoURL}restaurants/$photo');
                    }
                    print(updatedPhotoList);
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
                          // ClipRRect(
                          //   borderRadius: const BorderRadius.only(
                          //     topLeft: Radius.circular(
                          //       Dimensions.defaultSize,
                          //     ),
                          //     topRight: Radius.circular(
                          //       Dimensions.defaultSize,
                          //     ),
                          //   ),
                          //   child: CachedNetworkImage(
                          //     imageUrl: URL.photoURL +
                          //         'restaurants/' +
                          //         dataList[index]['photo'].split(',')[0],
                          //     fit: BoxFit.cover,
                          //     width: Get.width,
                          //     placeholder: (context, url) => Image.asset(
                          //       'assets/images/loading.jpg',
                          //       fit: BoxFit.cover,
                          //       width: Get.width,
                          //     ),
                          //     errorWidget: (context, url, error) => Image.asset(
                          //       'assets/images/loading.jpg',
                          //       fit: BoxFit.cover,
                          //       width: Get.width,
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
                              dataList[index]['price'] + 'RM',
                              style: const TextStyle(
                                fontSize: Dimensions.lgSize * 1.25,
                              ),
                            ),
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
                            child: Row(
                              children: [

                                const Icon(UniconsLine.map_marker),
                                const SizedBox(
                                  height: Dimensions.smSize / 2,
                                ),
                                Text(dataList[index]['address']),

                              ],
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                ElevatedButton(
                                  onPressed: () async {


                                    CartItem itemToAdd = CartItem(
                                        dutyId: dataList[index]['id'],
                                        name: dataList[index]['name'],
                                        photo: updatedPhotoList.first,
                                        price: dataList[index]['price'] == '' ? 0.00 : double.parse(dataList[index]['price']),
                                        quantity: 1,
                                        type: 'restaurants'
                                    );

                                    final prefs = await SharedPreferences.getInstance();
                                    print(prefs.getKeys());
                                    List<String>? restaurantStringList = prefs.getStringList('cart');
                                    List<CartItem> cartList = (restaurantStringList ?? []).map((itemJson) {
                                      final Map<String, dynamic> itemData = jsonDecode(itemJson);
                                      return CartItem(
                                        dutyId: itemData['duty_id'],
                                        name: itemData['name'],
                                        photo: updatedPhotoList.first,
                                        price: itemData['price'],
                                        quantity: itemData['quantity'],
                                      );
                                    }).toList();

Map sessionUser = await Session().user();
                                    if(sessionUser['id'] != null){
                                      await CartStorage.addToCart(itemToAdd);
                                      Cart(userId: sessionUser['id'], items: cartList).addItem(itemToAdd);
                                      SnackBarUtils.show(title: 'Item Added to cart successfully', isError: false);
                                    }else{
                                      SnackBarUtils.show(title: 'Please login first', isError: true);
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.lgSize,
                                    ),
                                    child: Text('Add to Cart'),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if(await Session().isLogin()){
                                      bookRestaurant(
                                          dataList[index]['id'],
                                          dataList[index]['price'],
                                          dataList[index]);
                                    }else{
                                      SnackBarUtils.show(title: 'Please Login first', isError: true);
                                    }

                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.lgSize,
                                    ),
                                    child: Text('Book Now'),
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
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  void bookRestaurant(restaurantId, totalPrice, dataList) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController _controller = TextEditingController();
          DateTime _selectedDate = DateTime.now();
          TimeOfDay _selectedTime = TimeOfDay.now();

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Enter Details'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(
                            Dimensions.smSize / 2,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: RGB.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusSize,
                            ),
                          ),
                          child: Text(
                            'Open At: ${formatTime(dataList['open_time'] ?? "00:00:00")} \nClose At: ${formatTime(dataList['close_time'] ?? "00:00:00")}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                      const SizedBox(
                        height: Dimensions.smSize,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        validator: RequiredValidator(
                            errorText: 'This field is required!'),
                        decoration: FormsUtils.inputStyle(
                          hintText: 'Number of People',
                        ),
                        cursorColor: RGB.dark,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Date: ${DateFormat('d-M-y').format(_selectedDate)}'),
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
                              if (picked != null && picked != _selectedTime) {
                                final DateTime now = DateTime.now();
                                final DateTime selectedDateTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    picked.hour,
                                    picked.minute);

                                DateTime open_time =
                                    getDateTime(dataList['open_time']);
                                DateTime close_time =
                                    getDateTime(dataList['close_time']);

                                if (selectedDateTime.isAfter(open_time) &&
                                    selectedDateTime.isBefore(close_time)) {
                                  setState(() {
                                    _selectedTime = picked;
                                    dateTimeError = false;
                                  });
                                } else {
                                  setState(() {
                                    _selectedTime = picked;

                                    dateTimeError = true;
                                  });
                                }
                              }
                            },
                            child: Text('Select Time'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Price: RM $totalPrice',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (dateTimeError) SizedBox(height: 20),
                      if (dateTimeError)
                        Container(
                          padding: const EdgeInsets.all(
                            Dimensions.smSize / 2,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: RGB.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusSize,
                            ),
                          ),
                          child: Text(
                            'Warning: Selected time is outside the open and close time range!',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        dateTimeError = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String numberOfPeople = _controller.text;

                      if (numberOfPeople.trim().isEmpty) {
                        SnackBarUtils.show(
                            title: 'Number of people cannot be empty',
                            isError: true);
                        return;
                      }

                      DateTime selectedDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      String formattedDateTime =
                          selectedDateTime.toUtc().toIso8601String();

                      DateTime open_time = getDateTime(dataList['open_time']);
                      DateTime close_time = getDateTime(dataList['close_time']);

                      final TimeOfDay selectedTime = TimeOfDay(
                        hour: _selectedTime.hour,
                        minute: _selectedTime.minute,
                      );
                      final TimeOfDay openTime = TimeOfDay(
                        hour: open_time.hour,
                        minute: open_time.minute,
                      );
                      final TimeOfDay closeTime = TimeOfDay(
                        hour: close_time.hour,
                        minute: close_time.minute,
                      );

                      if ((selectedTime.hour > openTime.hour ||
                              (selectedTime.hour == openTime.hour &&
                                  selectedTime.minute >= openTime.minute)) &&
                          (selectedTime.hour < closeTime.hour ||
                              (selectedTime.hour == closeTime.hour &&
                                  selectedTime.minute <= closeTime.minute))) {
                        if (selectedDateTime.isBefore(DateTime.now())) {
                          SnackBarUtils.show(
                              title: 'Date and Time is already past.',
                              isError: true);
                          return;
                        }

                        setState(() {
                          dateTimeError = false;
                        });
                        Map sessionUser = await Session().user();
                        bool isLogin = await Session().isLogin();
                        if (isLogin) {
                          EasyLoading.show();
                          // call api part
                          try {
                            EasyLoading.dismiss();
                            print(totalPrice);
                            if(totalPrice != ''){
                              Map sessionUser = await Session().user();
                              final String orderId = PaymentUtils().generateOrderId();
                              List data = [restaurantId,sessionUser['id'],totalPrice,numberOfPeople,formattedDateTime];
                              PaymentUtils().makePayment(dataList['name']!, double.parse(totalPrice), orderId, sessionUser['name'], sessionUser['email'], sessionUser['phone'],data,'restaurant', context).then((value) {
                              });
                            }else{
                              Response response = await Dio().post(
                                URL.bookRestaurantURL,
                                data: FormData.fromMap({
                                  'restaurant_id': restaurantId,
                                  'user_id': sessionUser['id'],
                                  'grand_total': totalPrice,
                                  'num_of_persons': numberOfPeople,
                                  'start_date': formattedDateTime,
                                  'end_date': formattedDateTime,
                                }),
                              );
                              Map<String, dynamic> data = response.data;
                              if (data['error']) {
                                EasyLoading.show();
                                SnackBarUtils.show(
                                    title: data['message'], isError: true);
                              } else {
                                EasyLoading.show();
                                SnackBarUtils.show(
                                    title: data['message'], isError: false);
                                Navigator.pop(context);
                              }
                            }




                          } catch (e) {
                            SnackBarUtils.show(
                                title: e.toString(), isError: true);
                          }
                        } else {
                          Get.toNamed('/signin');
                        }
                      } else {
                        setState(() {
                          dateTimeError = true;
                        });
                        SnackBarUtils.show(
                            title:
                                'Selected time is outside the open and close time range',
                            isError: true);
                      }
                    },
                    child: Text(
                      'Book',
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

  // functional task
  void initApp() async {
    // call api part
    try {
      Response response = await Dio().get(
        URL.restaurantURL,
      );
      Map data = response.data;
      print(data);
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataList = data['data']['restaurants'];
        isLoaded = true;
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    setState(() {});
  }

  List<Event> _getEventsForDay(DateTime day) {
    final events = myHotelPricingData[day] ?? [];
    return events;
  }
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    final events = days.expand((day) => _getEventsForDay(day)).toList();
    return events;
  }
  final myHotelPricingData = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

}
class Event {
  final String price;
  final bool lowest;
  final DateTime startDate;
  final DateTime endDate;

  const Event(this.price, this.lowest, this.startDate, this.endDate);

  @override
  String toString() => price;
}

List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(start.add(Duration(days: i)));
  }
  return days;
}
