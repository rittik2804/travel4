import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/widget/images_carousel.dart';
import 'package:unicons/unicons.dart';

import '../widget/hotel_room.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({super.key});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final roomsData = jsonDecode(Get.parameters['rooms']!);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = List<Room>.from(roomsData.map((roomData) => Room(
          id: roomData['id'].toString(),
          hotel_id: Get.parameters['hotel_id'].toString(),
          title: roomData['name'].toString(),
          imageUrl: '${roomData['picture']}'.toString(),
          bedType: roomData['bed_type'].toString(),
          room_size: roomData['room_size'].toString(),
          persons_allowed: roomData['persons_allowed'].toString(),
          breakfast: roomData['breakfast'].toString(),
        )));

    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        leadingWidth: Dimensions.defaultSize * 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Get.parameters['name'].toString(),
            ),
            Row(
              children: [
                const Icon(
                  UniconsLine.location_point,
                  color: RGB.lightDarker,
                  size: Dimensions.defaultSize,
                ),
                Expanded(
                  child: Text(
                    Get.parameters['location'].toString(),
                    maxLines: 1,
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
                        //  CachedNetworkImage(
                        //   imageUrl: Get.parameters['picture'].toString(),
                        //   width: Get.width,
                        //   fit: BoxFit.cover,
                        //   placeholder: (context, url) => Image.asset(
                        //     'assets/images/loading.jpg',
                        //     width: Get.width,
                        //     fit: BoxFit.cover,
                        //   ),
                        //   errorWidget: (context, url, error) => Image.asset(
                        //     'assets/images/loading.jpg',
                        //     width: Get.width,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
                      // Positioned(
                      //   top: Dimensions.defaultSize,
                      //   right: Dimensions.defaultSize,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       vertical: Dimensions.smSize / 2,
                      //       horizontal: Dimensions.smSize,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: RGB.dark.withOpacity(0.75),
                      //       borderRadius: BorderRadius.circular(
                      //         Dimensions.circleSize,
                      //       ),
                      //     ),
                      //     child: Row(
                      //       children: const [
                      //         Icon(
                      //           Icons.photo_library,
                      //           color: RGB.white,
                      //           size: Dimensions.lgSize,
                      //         ),
                      //         Text(
                      //           ' +11',
                      //           style: TextStyle(
                      //             color: RGB.white,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      Dimensions.defaultSize,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.parameters['name'].toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: Dimensions.lgSize + 4,
                            color: RGB.dark,
                          ),
                        ),
                        // Row(
                        //   children: const [
                        //     Icon(
                        //       Icons.star,
                        //       color: RGB.darkYellow,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //     Icon(
                        //       Icons.star,
                        //       color: RGB.darkYellow,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //     Icon(
                        //       Icons.star,
                        //       color: RGB.darkYellow,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //     Icon(
                        //       Icons.star,
                        //       color: RGB.darkYellow,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //     Icon(
                        //       Icons.star,
                        //       color: RGB.lightDarker,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: Dimensions.smSize / 2,
                        // ),
                        Row(
                          children: [
                            const Icon(
                              UniconsLine.location_point,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            Expanded(
                              child: Text(
                                Get.parameters['location'].toString(),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: Dimensions.smSize,
                                  color: RGB.lightDarker,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            Dimensions.smSize,
                          ),
                          decoration: BoxDecoration(
                            color: RGB.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusSize,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.exit_to_app,
                                    size: Dimensions.lgSize,
                                  ),
                                  SizedBox(
                                    width: Dimensions.smSize / 2,
                                  ),
                                  Text(
                                      'Check-in: ${formatTime(Get.parameters['check_in'] ?? "00:00:00")}')
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.rotate(
                                    angle: -math.pi,
                                    child: const Icon(
                                      Icons.exit_to_app,
                                      size: Dimensions.lgSize,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.smSize / 2,
                                  ),
                                  Text(
                                      'Check-in: ${formatTime(Get.parameters['check_out'] ?? "00:00:00")}')
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        // feature
                        // Row(
                        //   children: const [
                        //     Icon(
                        //       Icons.group,
                        //       color: RGB.lightDarker,
                        //       size: Dimensions.defaultSize,
                        //     ),
                        //     SizedBox(
                        //       width: Dimensions.smSize,
                        //     ),
                        //     Text('6 Guests'),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: Dimensions.smSize,
                        // ),
                        Row(
                          children: [
                            Icon(
                              Icons.wifi,
                              color: Get.parameters['wifi'] == "1"
                                  ? Colors.blueGrey
                                  : Colors.grey.shade300,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              'Wifi',
                              style: TextStyle(
                                color: Get.parameters['wifi'] == "1"
                                    ? Colors.blueGrey
                                    : Colors.grey.shade300,
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
                              Icons.pool,
                              color: Get.parameters['pool'] == "1"
                                  ? Colors.blueGrey
                                  : Colors.grey.shade300,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              'Pool',
                              style: TextStyle(
                                color: Get.parameters['pool'] == "1"
                                    ? Colors.blueGrey
                                    : Colors.grey.shade300,
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
                              Icons.restaurant,
                              color: Get.parameters['restaurant'] == "1"
                                  ? Colors.blueGrey
                                  : Colors.grey.shade300,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              'Restaurant',
                              style: TextStyle(
                                color: Get.parameters['restaurant'] == "1"
                                    ? Colors.blueGrey
                                    : Colors.grey.shade300,
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
                              Icons.local_bar,
                              color: Get.parameters['bar'] == "1"
                                  ? Colors.blueGrey
                                  : Colors.grey.shade300,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              'Bar',
                              style: TextStyle(
                                color: Get.parameters['bar'] == "1"
                                    ? Colors.blueGrey
                                    : Colors.grey.shade300,
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
                              Icons.local_parking_outlined,
                              color: Get.parameters['parking'] == "1"
                                  ? Colors.blueGrey
                                  : Colors.grey.shade300,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text(
                              'Parking',
                              style: TextStyle(
                                color: Get.parameters['parking'] == "1"
                                    ? Colors.blueGrey
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        // rooms
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Rooms',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        rooms.length > 0
                            ? HotelRooms(rooms: rooms)
                            : Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  'No Rooms Available',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // HotelRooms(rooms: rooms),
            // Container(
            //   padding: const EdgeInsets.all(
            //     Dimensions.defaultSize,
            //   ),
            //   decoration: BoxDecoration(
            //     color: RGB.primary.withOpacity(0.1),
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(
            //         Dimensions.defaultSize,
            //       ),
            //       topRight: Radius.circular(
            //         Dimensions.defaultSize,
            //       ),
            //     ),
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         '${Get.parameters['price']} RM',
            //         style: const TextStyle(
            //           fontSize: Dimensions.lgSize + 4,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //       ElevatedButton(
            //         onPressed: () async {
            //           Map sessionUser = await Session().user();
            //           bool isLogin = await Session().isLogin();
            //           if (isLogin) {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => HotelCalendarScreen(
            //                     hotelID: Get.parameters['id'].toString()),
            //               ),
            //             );

            //             // EasyLoading.show();
            //             // call api part
            //             // try {
            //             //   Response response = await Dio().post(
            //             //     URL.orderAddURL,
            //             //     data: FormData.fromMap({
            //             //       'type': 'hotel',
            //             //       'hotel_id': Get.parameters['id'],
            //             //       'staff_id': sessionUser['id'],
            //             //       'price': Get.parameters['price'],
            //             //     }),
            //             //   );
            //             //   Map data = jsonDecode(response.data);
            //             //   if (data['error']) {
            //             //     EasyLoading.dismiss();
            //             //     SnackBarUtils.show(
            //             //         title: data['message'], isError: true);
            //             //   } else {
            //             //     EasyLoading.dismiss();
            //             //     SnackBarUtils.show(
            //             //         title: data['message'], isError: false);
            //             //     if (mounted) {
            //             //       Get.offAllNamed('home');
            //             //     }
            //             //   }
            //             // } catch (e) {
            //             //   SnackBarUtils.show(
            //             //       title: e.toString(), isError: true);
            //             // }
            //           } else {
            //             Get.toNamed('/signin');
            //           }
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(
            //             horizontal: Dimensions.lgSize,
            //           ),
            //           child: Text('Book Now'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

String formatTime(String timeString) {
  // Split the input string into hours, minutes, and seconds
  var timeComponents = timeString.split(':');
  var hours = int.parse(timeComponents[0]);
  var minutes = int.parse(timeComponents[1]);
  var seconds = int.parse(timeComponents[2]);

  // Get the current date as a DateTime object
  var currentDate = DateTime.now();

  // Create a new DateTime object with the given time components and the current date
  var checkInDateTime = DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
    hours,
    minutes,
    seconds,
  );

  // Convert the DateTime object to microseconds since epoch
  var checkInMicroseconds = checkInDateTime.microsecondsSinceEpoch;

  // Create a new DateTime object from the microseconds value
  var checkIn = DateTime.fromMicrosecondsSinceEpoch(checkInMicroseconds);

  // Format the resulting DateTime object using DateFormat
  return DateFormat('h:mm a').format(checkIn);
}

DateTime getDateTime(String timeString) {
  // Split the input string into hours, minutes, and seconds
  var timeComponents = timeString.split(':');
  var hours = int.parse(timeComponents[0]);
  var minutes = int.parse(timeComponents[1]);
  var seconds = int.parse(timeComponents[2]);

  // Get the current date as a DateTime object
  var currentDate = DateTime.now();

  // Create a new DateTime object with the given time components and the current date
  var checkInDateTime = DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
    hours,
    minutes,
    seconds,
  );

  // Convert the DateTime object to microseconds since epoch
  var checkInMicroseconds = checkInDateTime.microsecondsSinceEpoch;

  // Create a new DateTime object from the microseconds value
  var checkIn = DateTime.fromMicrosecondsSinceEpoch(checkInMicroseconds);

  // Format the resulting DateTime object using DateFormat
  return checkIn;
}
