import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/models/cart_model.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/payment_util.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:travel/widget/images_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({super.key});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .enforced; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool isLoading = true;

  @override
  void initState() {
    _fetchHotelDataWithCalendar();
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  final myHotelPricingData = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  List<Event> _getEventsForDay(DateTime day) {
    final events = myHotelPricingData[day] ?? [];
    return events;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    final events = days.expand((day) => _getEventsForDay(day)).toList();
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      if (selectedDay.isBefore(today)) {
        SnackBarUtils.show(
          title: "Date is already passed",
          isError: true,
        );
        return;
      } else {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _rangeStart = null;
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });

        _selectedEvents.value = _getEventsForDay(selectedDay);
      }
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (start != null && end != null) {
      // Check if the selected range is valid
      bool isValidRange = true;
      for (final date in daysInRange(start, end)) {
        final events = myHotelPricingData[date];
        if (events != null) {
          for (final event in events) {
            if (event.price.toLowerCase() == "cc") {
              // The range is not valid
              isValidRange = false;
              break;
            }
          }
        }
        if (!isValidRange) {
          break;
        }
      }

      if (!isValidRange) {
        // Show an error message
        SnackBarUtils.show(
          title: "The selected range is not valid",
          isError: true,
        );
        return;
      }
    }
    if (start != null) {
      DateTime startDate = DateTime(start.year, start.month, start.day);
      DateTime nowDate = DateTime.now();
      nowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
      if (startDate.isBefore(nowDate)) {
        start = nowDate;
      }
    }

    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        leadingWidth: Dimensions.defaultSize * 2,
        title: Text(
          Get.parameters['name'].toString(),
        ),
        actions: [
          if (isLoading)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading..."),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          if (_selectedEvents.value.isEmpty && !isLoading)
            IconButton(
              onPressed: () {
                _fetchHotelDataWithCalendar();
              },
              icon: Icon(Icons.replay_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ImagesCarousel(
                          photos: Get.parameters['picture']!.split(','),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      Dimensions.defaultSize,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.roofing_outlined,
                              color: Colors.blueGrey,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              Get.parameters['room_size']!,
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.bed_outlined,
                              color: Colors.blueGrey,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              Get.parameters['bed_type'].toString(),
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              color: Colors.blueGrey,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              Get.parameters['persons_allowed']!,
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.local_dining_outlined,
                              color: Colors.blueGrey,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              Get.parameters['breakfast']!,
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        // rooms
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),

                        Column(
                          children: [
                            TableCalendar<Event>(
                              firstDay: kFirstDay,
                              lastDay: kLastDay,
                              focusedDay: _focusedDay,
                              enabledDayPredicate: (day) {
                                final events = myHotelPricingData[day];
                                if (events != null) {
                                  for (final event in events) {
                                    if (event.price.toLowerCase() == "cc") {
                                      return false;
                                    }
                                  }
                                }
                                return true;
                              },
                              rangeStartDay: _rangeStart,
                              rangeEndDay: _rangeEnd,
                              rangeSelectionMode: _rangeSelectionMode,
                              eventLoader: _getEventsForDay,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              onDaySelected: _onDaySelected,
                              onRangeSelected: _onRangeSelected,
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                              calendarBuilders: CalendarBuilders(
                                singleMarkerBuilder: (context, date, event) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: event.lowest
                                          ? RGB.succeeLight.withOpacity(0.7)
                                          : Colors.black,
                                    ),
                                    width: 10,
                                    height: 8,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 250.0),
                            // Expanded(
                            //   child: ValueListenableBuilder<List<Event>>(
                            //     valueListenable: _selectedEvents,
                            //     builder: (context, value, _) {
                            //       final uniqueEvents = value.toSet().toList();
                            //       return ListView.builder(
                            //         itemCount: uniqueEvents.length,
                            //         shrinkWrap: true,
                            //         physics: NeverScrollableScrollPhysics(),
                            //         itemBuilder: (context, index) {
                            //           final event = uniqueEvents[index];
                            //           final dateRange =
                            //               "${DateFormat.yMMMd().format(event.startDate)} - ${DateFormat.yMMMd().format(event.endDate)}";
                            //           return Container(
                            //             margin: const EdgeInsets.symmetric(
                            //               horizontal: 12.0,
                            //               vertical: 4.0,
                            //             ),
                            //             decoration: BoxDecoration(
                            //               border: Border.all(),
                            //               borderRadius:
                            //                   BorderRadius.circular(12.0),
                            //             ),
                            //             child: ListTile(
                            //               onTap: () {
                            //                 showBookDialog(
                            //                     context,
                            //                     event.price,
                            //                     dateRange,
                            //                     event.startDate,
                            //                     event.endDate);
                            //               },
                            //               title: event.lowest
                            //                   ? Container(
                            //                       padding: EdgeInsets.symmetric(
                            //                           horizontal: 12,
                            //                           vertical: 8),
                            //                       decoration: BoxDecoration(
                            //                         color: RGB.succeeLight
                            //                             .withOpacity(0.15),
                            //                         borderRadius:
                            //                             BorderRadius.all(
                            //                                 Radius.elliptical(
                            //                                     10, 10)),
                            //                       ),
                            //                       child: Text(
                            //                           'RM ${event.price} \nLowest Price\n$dateRange'),
                            //                     )
                            //                   : Text(
                            //                       'RM ${event.price}\n$dateRange'),
                            //             ),
                            //           );
                            //         },
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isLoading ||
              (_rangeStart == null && _selectedDay == null)
          ? null
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    print('Photo:   ${Get.parameters['picture']!}');
                    final priceAndDateRange = _getPriceAndDateRange();
                    double price = double.parse(priceAndDateRange.split('\n')[0].split(': ')[1]);

                    CartItem itemToAdd = CartItem(
                      dutyId: Get.parameters['id']!,
                      name: Get.parameters['name']!,
                      photo: Get.parameters['picture']!,
                      price: price,
                      quantity: 1,
                      type: 'room'
                    );

                    final prefs = await SharedPreferences.getInstance();
                    List<String>? cartStringList = prefs.getStringList('cart');
                    List<CartItem> cartList = (cartStringList ?? []).map((itemJson) {
                      final Map<String, dynamic> itemData = jsonDecode(itemJson);
                      return CartItem(
                        dutyId: itemData['duty_id'],
                        name: itemData['name'],
                        photo: itemData['photo'],
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
                      SnackBarUtils.show(title: 'Something went wrong!, Please login first', isError: true);

                    }
                  },
                  label: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.blueGrey,
                  elevation: 10,
                ),
              ),
              PriceRangeButton(
                  onPressed: () {
                    final priceAndDateRange = _getPriceAndDateRange();
                    final price = priceAndDateRange.split('\n')[0].split(': ')[1];
                    final dateRange =
                        priceAndDateRange.split('\n')[1].split(': ')[1];
                    showBookDialog(context, price, dateRange,
                        _rangeStart ?? _selectedDay, _rangeEnd ?? _selectedDay);
                  },
                  priceAndDateRange: 'Book Now',
                ),
            ],
          ),
    );
  }

  void _fetchHotelDataWithCalendar() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        '${URL.hotelCalenderURL}${Get.parameters['hotel_id']}',
        queryParameters: {'room_id': Get.parameters['id']},
      );

      final decodedResponse = response.data;

      final newHotelPricingData = <DateTime, List<Event>>{};

      for (final hotelPricing in decodedResponse['data']['hotel_pricing']) {
        final startDate = DateTime.parse(hotelPricing['start_date']);
        final endDate = DateTime.parse(hotelPricing['end_date']);
        final event = Event(
            hotelPricing['price'], hotelPricing['lowest'], startDate, endDate);

        for (final date in daysInRange(startDate, endDate)) {
          if (newHotelPricingData[date] != null) {
            newHotelPricingData[date]!.add(event);
          } else {
            newHotelPricingData[date] = [event];
          }
        }
      }
      if (mounted) {
        setState(() {
          myHotelPricingData
            ..clear()
            ..addAll(newHotelPricingData);
          _selectedEvents.value = _getEventsForDay(_selectedDay!);
          isLoading = false;
        });
      }
    } catch (e) {
      SnackBarUtils.show(
        title: "An error occured",
        isError: true,
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // String _getPriceAndDateRange() {
  //   if (_rangeStart != null && _rangeEnd != null) {
  //     final events = _getEventsForRange(_rangeStart!, _rangeEnd!);
  //     final totalPrice = events.fold(0.0, (sum, event) {
  //       return sum + double.parse(event.price);
  //     });
  //     final dateRange =
  //         "${DateFormat.yMMMd().format(_rangeStart!)} - ${DateFormat.yMMMd().format(_rangeEnd!)}";
  //     return "Price: $totalPrice\nDate Range: $dateRange";
  //   }
  //   if (_selectedDay != null) {
  //     final events = _getEventsForDay(_selectedDay!);
  //     final totalPrice =
  //         events.fold(0.0, (sum, event) => sum + double.parse(event.price));
  //     final dateRange = "${DateFormat.yMMMd().format(_selectedDay!)}";
  //     return "Price: $totalPrice\nDate: $dateRange";
  //   } else {
  //     return "";
  //   }
  // }

  String _getPriceAndDateRange() {
    if (_rangeStart != null && _rangeEnd != null) {
      final rangeEnd = _rangeEnd!.subtract(Duration(days: 1));
      final events = _getEventsForRange(_rangeStart!, rangeEnd);
      final totalPrice = events.fold(0.0, (sum, event) {
        return sum + double.parse(event.price);
      });
      final dateRange =
          "${DateFormat.yMMMd().format(_rangeStart!)} - ${DateFormat.yMMMd().format(rangeEnd)}";
      return "Price: $totalPrice\nDate Range: $dateRange";
    }
    if (_selectedDay != null) {
      final events = _getEventsForDay(_selectedDay!);
      final totalPrice =
          events.fold(0.0, (sum, event) => sum + double.parse(event.price));
      final dateRange = "${DateFormat.yMMMd().format(_selectedDay!)}";
      return "Price: $totalPrice\nDate: $dateRange";
    } else {
      return "";
    }
  }

  void book(totalPrice, start_date, end_date) async {
    Map sessionUser = await Session().user();
    bool isLogin = await Session().isLogin();
    if (isLogin) {
      EasyLoading.show();
      try {
        Response response = await Dio().post(
          URL.bookHotelURL,
          data: FormData.fromMap({
            'hotel_id': Get.parameters['hotel_id'],
            'room_id': Get.parameters['id'],
            'user_id': sessionUser['id'],
            'start_date': start_date,
            'end_date': end_date,
            'grand_total': totalPrice,
          }),
        );
        print(response.statusCode);
        Map<String, dynamic> data = response.data;
        if (data['error']) {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: true);
        } else {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: false);
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
        SnackBarUtils.show(title: e.toString(), isError: true);
      }
      setState(() {
        _rangeStart = _rangeEnd = null;
        _selectedEvents.value = _getEventsForDay(_focusedDay);
      });
    } else {
      SnackBarUtils.show(title: 'Please Login first', isError: true);
    }
  }

  void showBookDialog(BuildContext context, String price, String dateRange,
      start_date, end_date) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: $price'),
              SizedBox(height: 8),
              Text('Date Range: $dateRange'),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if(await Session().isLogin()){
                 if(price != '0.0'){
                   Map sessionUser = await Session().user();
                   final String orderId = PaymentUtils().generateOrderId();
                   List data = [price,start_date,end_date];
                   PaymentUtils().makePayment(Get.parameters['name']!, double.parse('100.00'), orderId, sessionUser['name'], sessionUser['email'], sessionUser['phone'],data,'room', context).then((value){
                     // Navigator.pop(context);
                     // book(price, start_date, end_date);
                   });
                 }else{

                   book(price, start_date, end_date);
                   Navigator.pop(context);
                   print('Booked');
                 }
                }else{
                  SnackBarUtils.show(title: 'Please Login first', isError: true);
                }

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
  }
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

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 2, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);

List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(start.add(Duration(days: i)));
  }
  return days;
}

class PriceRangeButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String priceAndDateRange;

  const PriceRangeButton({
    Key? key,
    required this.onPressed,
    required this.priceAndDateRange,
  }) : super(key: key);

  @override
  _PriceRangeButtonState createState() => _PriceRangeButtonState();
}

class _PriceRangeButtonState extends State<PriceRangeButton> {
  @override
  Widget build(BuildContext context) {
    return widget.priceAndDateRange.trim() != ""
        ? Padding(
            padding: EdgeInsets.only(left: 30),
            child: FloatingActionButton.extended(
              onPressed: widget.onPressed,
              label: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  widget.priceAndDateRange,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              backgroundColor: Colors.blueGrey,
              elevation: 10,
            ),
          )
        : SizedBox.shrink();
  }
}
