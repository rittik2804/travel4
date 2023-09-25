import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel/config/session.dart';
import 'package:travel/screens/paymrnt_status_screen.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import '../config/url.dart';
import '../utils/payment_util.dart';

class HotelCalendarScreen extends StatefulWidget {
  final String hotelID;
  HotelCalendarScreen({required this.hotelID});
  @override
  _HotelCalendarScreenState createState() => _HotelCalendarScreenState();
}

class _HotelCalendarScreenState extends State<HotelCalendarScreen> {
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
    return myHotelPricingData[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return days.expand((day) => _getEventsForDay(day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
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

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (start != null && start.isBefore(DateTime.now())) {
      start = DateTime.now();
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
      appBar: AppBar(
        title: Text('Hotel Calender'),
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
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                final uniqueEvents = value.toSet().toList();
                return ListView.builder(
                  itemCount: uniqueEvents.length,
                  itemBuilder: (context, index) {
                    final event = uniqueEvents[index];
                    final dateRange =
                        "${DateFormat.yMMMd().format(event.startDate)} - ${DateFormat.yMMMd().format(event.endDate)}";
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          showBookDialog(context, event.price, dateRange,
                              event.startDate, event.endDate);
                        },
                        title: event.lowest
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: RGB.succeeLight.withOpacity(0.15),
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(10, 10)),
                                ),
                                child: Text(
                                    'RM ${event.price} \nLowest Price\n$dateRange'),
                              )
                            : Text('RM ${event.price}\n$dateRange'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isLoading ||
              _rangeStart == null ||
              _rangeEnd == null
          ? null
          : PriceRangeButton(
              onPressed: () {
                final priceAndDateRange = _getPriceAndDateRange();
                final price = priceAndDateRange.split('\n')[0].split(': ')[1];
                final dateRange =
                    priceAndDateRange.split('\n')[1].split(': ')[1];
                showBookDialog(
                    context, price, dateRange, _rangeStart, _rangeEnd);
              },
              priceAndDateRange: _getPriceAndDateRange(),
            ),
    );
  }

  void _fetchHotelDataWithCalendar() async {
    final response = await Dio().get(
      '${URL.hotelCalenderURL}${widget.hotelID}',
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

    setState(() {
      myHotelPricingData
        ..clear()
        ..addAll(newHotelPricingData);
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
      isLoading = false;
    });
  }

  String _getPriceAndDateRange() {
    if (_rangeStart != null && _rangeEnd != null) {
      final events = _getEventsForRange(_rangeStart!, _rangeEnd!);
      debugPrint('Events: $events'); // Debugging statement
      final totalPrice =
          events.fold(0.0, (sum, event) => sum + double.parse(event.price));

      final dateRange = events.isNotEmpty
          ? "${DateFormat.yMMMd().format(events.first.startDate)} - ${DateFormat.yMMMd().format(events.first.endDate)}"
          : "";
      return "Price: $totalPrice\nDate Range: $dateRange";
    } else if (_selectedDay != null) {
      final events = _getEventsForDay(_selectedDay!);
      final totalPrice =
          events.fold(0.0, (sum, event) => sum + double.parse(event.price));
      print('Total price: $totalPrice');
      final dateRange = events.isNotEmpty
          ? "${DateFormat.yMMMd().format(events.first.startDate)} - ${DateFormat.yMMMd().format(events.first.endDate)}"
          : "";
      return "Price: $totalPrice\nDate Range: $dateRange";
    } else {
      return "";
    }
  }

  void book(totalPrice, start_date, end_date,orderID) async {
    Map sessionUser = await Session().user();
    bool isLogin = await Session().isLogin();
    if (isLogin) {
      EasyLoading.show();
      try {
        final response = await Dio().post(
          URL.bookHotelURL,
          data: FormData.fromMap({
            'hotel_id': widget.hotelID,
            'user_id': sessionUser['id'],
            'start_date': start_date,
            'end_date': end_date,
            'grand_total': totalPrice,
          }),
        );
        Map<String, dynamic> data = response.data;
        if (data['error']) {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: true);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['0',orderID.toString(),'No Payment Made','Your_payment_was_declined._Thank_you.']),));

        } else {
          EasyLoading.dismiss();
          SnackBarUtils.show(title: data['message'], isError: false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen(paymentData: ['1',orderID.toString(),'No Payment Made','Your_payment_was_successful._Thank_you.']),));

        }
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarUtils.show(title: e.toString(), isError: true);
      }
      setState(() {
        _rangeStart = _rangeEnd = null;
        _selectedEvents.value = _getEventsForDay(_focusedDay);
      });
    }
  }

  void showBookDialog(BuildContext context, String price, String dateRange,
      start_date, end_date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
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
                final String orderId = PaymentUtils().generateOrderId();
                if(price != '0.0'){
                Map sessionUser = await Session().user();
                List data = [];
                PaymentUtils().makePayment(Get.parameters['name']!, double.parse(price), orderId, sessionUser['name'], sessionUser['email'], sessionUser['phone'],data,'hotel',context);

                }else{
                book(price, start_date, end_date,orderId);
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

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
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
