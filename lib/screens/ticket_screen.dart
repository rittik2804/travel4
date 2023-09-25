import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

import '../config/session.dart';
import '../config/url.dart';
import '../models/cart_model.dart';
import '../utils/dimensions_utils.dart';
import '../utils/payment_util.dart';
import '../utils/rgb_utils.dart';
import '../utils/screen_size.dart';
import '../utils/snackbar__utils.dart';
import '../widget/images_carousel.dart';
import 'homestay_detail_screen.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isLoaded = false;
  bool dateTimeError = false;
  List dataList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: SafeArea(
        child: isLoaded ? Container(
          padding:  EdgeInsets.all(
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
                updatedPhotoList.add('${URL.photoURL}ticket/$photo');
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
                      child: Row(
                        children: [
                          const Icon(UniconsLine.map_marker),
                          const SizedBox(
                            height: Dimensions.smSize / 2,
                          ),
                          Text(dataList[index]['description']),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   dataList[index]['price'] + 'RM',
                          //   style: const TextStyle(
                          //     fontSize: Dimensions.lgSize * 1.25,
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed: () async {
                              /*
                              List _selectedCategories = [];
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  DateTime? _selectedDate;
                                  TimeOfDay _selectedTime =
                                  TimeOfDay.now();

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: Text('Enter Details'),
                                        content: Container(
                                          width: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(
                                                      Dimensions.smSize /
                                                          2,
                                                    ),
                                                    width:
                                                    double.infinity,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: RGB.blue
                                                          .withOpacity(
                                                          0.15),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                        Dimensions
                                                            .radiusSize,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Open At: ${formatTime(dataList[index]['open_time'] ?? "00:00:00")} \nClose At: ${formatTime(dataList[index]['close_time'] ?? "00:00:00")}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  height:
                                                  Dimensions.smSize,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Date: ${_selectedDate != null ? DateFormat('d-M-y').format(_selectedDate!) : ""} '),
                                                    TextButton(
                                                      onPressed:
                                                          () async {
                                                        final DateTime?
                                                        picked =
                                                        await showDatePicker(
                                                          context:
                                                          context,
                                                          initialDate:
                                                          DateTime
                                                              .now(),
                                                          firstDate:
                                                          DateTime
                                                              .now(),
                                                          lastDate:
                                                          DateTime(
                                                              2101),
                                                        );
                                                        if (picked !=
                                                            null &&
                                                            picked !=
                                                                _selectedDate)
                                                          setState(() {
                                                            _selectedDate =
                                                                picked;
                                                          });
                                                      },
                                                      child: Text(
                                                          'Select Date'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Time: ${_selectedTime.format(context)}'),
                                                    TextButton(
                                                      onPressed:
                                                          () async {
                                                        final TimeOfDay?
                                                        picked =
                                                        await showTimePicker(
                                                          context:
                                                          context,
                                                          initialTime:
                                                          _selectedTime,
                                                        );
                                                        if (picked !=
                                                            null &&
                                                            picked !=
                                                                _selectedTime) {
                                                          final DateTime
                                                          now =
                                                          DateTime
                                                              .now();
                                                          final DateTime
                                                          selectedDateTime =
                                                          DateTime(
                                                              now
                                                                  .year,
                                                              now
                                                                  .month,
                                                              now.day,
                                                              picked
                                                                  .hour,
                                                              picked
                                                                  .minute);

                                                          DateTime
                                                          open_time =
                                                          getDateTime(
                                                              dataList[index]
                                                              [
                                                              'open_time']);
                                                          DateTime
                                                          close_time =
                                                          getDateTime(
                                                              dataList[index]
                                                              [
                                                              'close_time']);

                                                          if (selectedDateTime
                                                              .isAfter(
                                                              open_time) &&
                                                              selectedDateTime
                                                                  .isBefore(
                                                                  close_time)) {
                                                            setState(() {
                                                              _selectedTime =
                                                                  picked;
                                                              dateTimeError =
                                                              false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              _selectedTime =
                                                                  picked;

                                                              dateTimeError =
                                                              true;
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                          'Select Time'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Select Category',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                SizedBox(
                                                  width: kIsWeb
                                                      ? !ResponsiveHelper
                                                      .isMobile(
                                                      context)
                                                      ? MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.35
                                                      : MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      1
                                                      : null,
                                                  child: Wrap(
                                                    spacing: 8.0,
                                                    children: dataList[
                                                    index]
                                                    ['categories']
                                                        .map<Widget>(
                                                            (category) {
                                                          return MultiLineChipTicket(
                                                            label: category[
                                                            'name'],
                                                            price: category[
                                                            'price'],
                                                            onPressed: () {
                                                              setState(() {
                                                                final index = _selectedCategories.indexWhere((c) =>
                                                                c['name'] ==
                                                                    category[
                                                                    'name']);
                                                                if (index !=
                                                                    -1) {
                                                                  _selectedCategories
                                                                      .removeAt(
                                                                      index);
                                                                } else {
                                                                  _selectedCategories
                                                                      .add({
                                                                    ...category,
                                                                    'quantity':
                                                                    1
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            onQuantityChanged:
                                                                (quantity) {
                                                              setState(() {
                                                                final index = _selectedCategories.indexWhere((c) =>
                                                                c['name'] ==
                                                                    category[
                                                                    'name']);
                                                                if (index !=
                                                                    -1) {
                                                                  _selectedCategories[
                                                                  index] = {
                                                                    ..._selectedCategories[
                                                                    index],
                                                                    'quantity':
                                                                    quantity
                                                                  };
                                                                }
                                                              });
                                                            },
                                                            selected:
                                                            _selectedCategories,
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                                Text(
                                                  'Total Price: RM ${_selectedCategories.fold(0.0, (total, category) => total + double.parse(category['price'].toString()) * int.parse(category['quantity'].toString())).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                if (dateTimeError)
                                                  SizedBox(height: 20),
                                                if (dateTimeError)
                                                  Container(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(
                                                      Dimensions.smSize /
                                                          2,
                                                    ),
                                                    width:
                                                    double.infinity,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: RGB.blue
                                                          .withOpacity(
                                                          0.15),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                        Dimensions
                                                            .radiusSize,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Warning: Selected time is outside the open and close time range!',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w300,
                                                          color: Colors
                                                              .redAccent),
                                                    ),
                                                  ),
                                              ],
                                            ),
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
                                              if (_selectedCategories
                                                  .isEmpty) {
                                                SnackBarUtils.show(
                                                    title:
                                                    'Select a category first.',
                                                    isError: true);
                                                return;
                                              }
                                              if (_selectedDate == null) {
                                                SnackBarUtils.show(
                                                    title:
                                                    'Select a date first.',
                                                    isError: true);
                                                return;
                                              }
                                              DateTime selectedDateTime =
                                              DateTime(
                                                _selectedDate!.year,
                                                _selectedDate!.month,
                                                _selectedDate!.day,
                                                _selectedTime.hour,
                                                _selectedTime.minute,
                                              );
                                              String formattedDateTime =
                                              selectedDateTime
                                                  .toUtc()
                                                  .toIso8601String();
                                              setState(() {
                                                dateTimeError = false;
                                              });
                                              CartItem itemToAdd = CartItem(
                                                  dutyId: dataList[index]
                                                  ['id'],
                                                  name: dataList[index]
                                                  ['name'],
                                                  photo: updatedPhotoList
                                                      .first,
                                                  price: double.parse(_selectedCategories
                                                      .fold(
                                                      0.0,
                                                          (total, category) =>
                                                      total +
                                                          double.parse(category['price']
                                                              .toString()) *
                                                              int.parse(
                                                                  category['quantity'].toString()))
                                                      .toStringAsFixed(2)),
                                                  quantity: 1,
                                                  type: 'activities');

                                              final prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              print(prefs.getKeys());
                                              List<String>?
                                              restaurantStringList =
                                              prefs.getStringList(
                                                  'cart');
                                              List<CartItem> cartList =
                                              (restaurantStringList ??
                                                  [])
                                                  .map((itemJson) {
                                                final Map<String, dynamic>
                                                itemData =
                                                jsonDecode(itemJson);
                                                return CartItem(
                                                  dutyId:
                                                  itemData['duty_id'],
                                                  name: itemData['name'],
                                                  photo: updatedPhotoList
                                                      .first,
                                                  price:
                                                  itemData['price'],
                                                  quantity: itemData[
                                                  'quantity'],
                                                );
                                              }).toList();

                                              Map sessionUser =
                                              await Session().user();
                                              if (sessionUser['id'] !=
                                                  null) {
                                                await CartStorage
                                                    .addToCart(itemToAdd);
                                                Cart(
                                                    userId:
                                                    sessionUser[
                                                    'id'],
                                                    items: cartList)
                                                    .addItem(itemToAdd);
                                                SnackBarUtils.show(
                                                    title:
                                                    'Item Added to cart successfully',
                                                    isError: false);
                                                Navigator.pop(context);
                                              } else {
                                                SnackBarUtils.show(title: 'Please login first', isError: true);
                                              }
                                            },
                                            child: Text(
                                              'Add to cart',
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                              */
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.lgSize,
                              ),
                              child: Text('Add to Cart'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // bookActivity(
                              //   dataList[index]['id'],
                              //   dataList[index],
                              // );
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
            child: Text('No ticket found!'),
          ),
        ) : Center(child: CircularProgressIndicator()) ,
      ),
    );
  }

  void bookActivity(activityId, dataList) {
    List _selectedCategories = [];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        DateTime? _selectedDate;
        TimeOfDay _selectedTime = TimeOfDay.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Details'),
              content: Container(
                width: 300,
                child: SingleChildScrollView(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Date: ${_selectedDate != null ? DateFormat('d-M-y').format(_selectedDate!) : ""} '),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
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
                      SizedBox(height: 8),
                      Text(
                        'Select Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: kIsWeb
                            ? !ResponsiveHelper.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.35
                            : MediaQuery.of(context).size.width * 1
                            : null,
                        child: Wrap(
                          spacing: 8.0,
                          children:
                          dataList['categories'].map<Widget>((category) {
                            return MultiLineChipTicket(
                              label: category['name'],
                              price: category['price'],
                              onPressed: () {
                                setState(() {
                                  final index = _selectedCategories.indexWhere(
                                          (c) => c['name'] == category['name']);
                                  if (index != -1) {
                                    _selectedCategories.removeAt(index);
                                  } else {
                                    _selectedCategories
                                        .add({...category, 'quantity': 1});
                                  }
                                });
                              },
                              onQuantityChanged: (quantity) {
                                setState(() {
                                  final index = _selectedCategories.indexWhere(
                                          (c) => c['name'] == category['name']);
                                  if (index != -1) {
                                    _selectedCategories[index] = {
                                      ..._selectedCategories[index],
                                      'quantity': quantity
                                    };
                                  }
                                });
                              },
                              selected: _selectedCategories,
                            );
                          }).toList(),
                        ),
                      ),
                      Text(
                        'Total Price: RM ${_selectedCategories.fold(0.0, (total, category) => total + double.parse(category['price'].toString()) * int.parse(category['quantity'].toString())).toStringAsFixed(2)}',
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
                    if (_selectedCategories.isEmpty) {
                      SnackBarUtils.show(
                          title: 'Select a category first.', isError: true);
                      return;
                    }
                    if (_selectedDate == null) {
                      SnackBarUtils.show(
                          title: 'Select a date first.', isError: true);
                      return;
                    }
                    DateTime selectedDateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    String formattedDateTime =
                    selectedDateTime.toUtc().toIso8601String();

                    // DateTime open_time = getDateTime(dataList['open_time']);
                    // DateTime close_time = getDateTime(dataList['close_time']);

                    // final TimeOfDay selectedTime = TimeOfDay(
                    //   hour: _selectedTime.hour,
                    //   minute: _selectedTime.minute,
                    // );
                    // final TimeOfDay openTime = TimeOfDay(
                    //   hour: open_time.hour,
                    //   minute: open_time.minute,
                    // );
                    // final TimeOfDay closeTime = TimeOfDay(
                    //   hour: close_time.hour,
                    //   minute: close_time.minute,
                    // );

                    // if ((selectedTime.hour > openTime.hour ||
                    //         (selectedTime.hour == openTime.hour &&
                    //             selectedTime.minute >= openTime.minute)) &&
                    //     (selectedTime.hour < closeTime.hour ||
                    //         (selectedTime.hour == closeTime.hour &&
                    //             selectedTime.minute <= closeTime.minute))) {
                    // if (selectedDateTime.isBefore(DateTime.now())) {
                    //   SnackBarUtils.show(
                    //       title: 'Date and Time is already past.',
                    //       isError: true);
                    //   return;
                    // }
                    setState(() {
                      dateTimeError = false;
                    });
                    Map sessionUser = await Session().user();
                    bool isLogin = await Session().isLogin();
                    if (isLogin) {
                      final categories = _selectedCategories
                          .map((category) => {
                        'category_id': category['id'],
                        'quantity': category['quantity'],
                      })
                          .toList();

                      final json = jsonEncode(categories);

                      // call api part
                      print(json);
                      try {
                        String totalPrice = _selectedCategories
                            .fold(
                            0.0,
                                (total, category) =>
                            total +
                                double.parse(category['price'].toString()) *
                                    int.parse(
                                        category['quantity'].toString()))
                            .toStringAsFixed(2);
                        if (totalPrice != '') {
                          Map sessionUser = await Session().user();
                          final String orderId =
                          PaymentUtils().generateOrderId();
                          print(dataList['name']);
                          print(json);
                          List<String> data = [activityId,json,sessionUser['id'],totalPrice,formattedDateTime];
                          PaymentUtils()
                              .makePayment(
                              dataList['name'].toString().replaceAll('&', 'and'),
                              double.parse(totalPrice),
                              orderId,
                              sessionUser['name'],
                              sessionUser['email'],
                              sessionUser['phone'],data,'activity',
                              context);
                        } else {
                          final response = await Dio().post(
                            URL.bookActivityURL,
                            data: FormData.fromMap({
                              'activity_id': activityId,
                              'category_id': json,
                              'user_id': sessionUser['id'],
                              'grand_total': _selectedCategories
                                  .fold(
                                  0.0,
                                      (total, category) =>
                                  total +
                                      double.parse(category['price']
                                          .toString()) *
                                          int.parse(category['quantity']
                                              .toString()))
                                  .toStringAsFixed(2),
                              'start_date': formattedDateTime,
                              'end_date': formattedDateTime,
                            }),
                          );
                          Map<String, dynamic> data = response.data;
                          if (data['error']) {
                            SnackBarUtils.show(
                                title: data['message'], isError: true);
                          } else {
                            SnackBarUtils.show(
                                title: data['message'], isError: false);
                          }
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        SnackBarUtils.show(title: e.toString(), isError: true);
                      }
                    } else {
                      SnackBarUtils.show(title: 'Please login first', isError: true);
                      Get.toNamed('/signin');
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
      },
    );
  }
  Future<void> book(activityId,json,userId,totalPrice,formattedDateTime) async {
    final response = await Dio().post(
      URL.bookActivityURL,
      data: FormData.fromMap({
        'activity_id': activityId,
        'category_id': json,
        'user_id': userId,
        'grand_total': totalPrice,
        'start_date': formattedDateTime,
        'end_date': formattedDateTime,
      }),
    );
    Map<String, dynamic> data = response.data;
    if (data['error']) {
      SnackBarUtils.show(
          title: data['message'], isError: true);
    } else {
      SnackBarUtils.show(
          title: data['message'], isError: false);
    }
    Navigator.of(context).pop();
  }
  void initApp() async {
    // call api part
    try {
      final response = await Dio().get(
        URL.ticketURL,
      );
      Map data = response.data;
      print(data);
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataList = data['data']['ticket'];
        isLoaded = true;
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    setState(() {});
    print(dataList);
  }
}
class MultiLineChipTicket extends StatelessWidget {
  final String label;
  final String price;
  final VoidCallback? onPressed;
  final List selected;
  final Function(int)? onQuantityChanged;

  const MultiLineChipTicket({
    Key? key,
    required this.label,
    required this.price,
    this.onPressed,
    required this.selected,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = selected.any((category) => category['name'] == label);
    final category = isSelected
        ? selected.firstWhere((category) => category['name'] == label)
        : null;
    final quantity = category != null ? category['quantity'] : 0;

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: kIsWeb
            ? !ResponsiveHelper.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.8
            : MediaQuery.of(context).size.width * 1
            : null,
        margin: EdgeInsets.only(bottom: 5),
        decoration: ShapeDecoration(
          color: isSelected ? Colors.blueGrey : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : Theme.of(context).dividerColor,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "$label (RM $price)",
                softWrap: true,
                style: TextStyle(
                  fontSize: isSelected ? 10 : 12,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (isSelected)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (quantity > 1) {
                        onQuantityChanged?.call(quantity - 1);
                      }
                    },
                  ),
                  Container(
                    width: 30,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(Dimensions.radiusSize),
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: Center(
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => onQuantityChanged?.call(quantity + 1),
                  ),
                ],
              ),
            if (!isSelected)
              Container(
                width: 40,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSize),
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor),
                ),
                child: Center(
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
