import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map sessionUser = {};
  bool isLogin = false;
  bool isLoaded = false;
  List hotelDataList = [];
  List carDataList = [];
  List packagesDataList = [];
  List dutyDataList = [];
  List restaurantDataList = [];
  List activityDataList = [];
  List homestayDataList = [];

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? isLogin
            ? SizedBox(
                height: Get.height,
                child: DefaultTabController(
                  length: 6,
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        labelColor: RGB.dark,
                        tabs: [
                          Tab(
                            text: 'Hotels',
                            icon: Icon(Icons.apartment_outlined),
                          ),
                          Tab(
                            text: 'Cars',
                            icon: Icon(Icons.local_taxi_outlined),
                          ),
                          Tab(
                            text: 'Packages',
                            icon: Icon(Icons.redeem_outlined),
                          ),
                          Tab(
                            text: 'Duty',
                            icon: Icon(Icons.shopping_bag_outlined),
                          ),
                          Tab(
                            text: 'Restaurant',
                            icon: Icon(Icons.restaurant_outlined),
                          ),
                          Tab(
                            text: 'Activity',
                            icon: Icon(Icons.calendar_month_outlined),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [

                            hotelDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: hotelDataList.length,
                                      itemBuilder: (context, index) {
                                        hotelDataList[index]['name'] == null ? hotelDataList[index]['name'] = '': hotelDataList[index]['name'];
                                        print(hotelDataList[index]['name']);
                                        print((hotelDataList[index]['name']) == null);
                                        return dataView(
                                          "Hotel Name: " + hotelDataList[index]['name']+
                                              "\nRoom: " +
                                              hotelDataList[index]['room_name'],
                                          formatDateRange(
                                              hotelDataList[index]
                                              ['start_date'],
                                              hotelDataList[index]['end_date']),
                                          hotelDataList[index]['price'] + 'RM',
                                          hotelDataList[index]['status'],
                                          hotelDataList,
                                          index,
                                          type: 'hotel',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no hotels order!'),
                                  ),
                            carDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: carDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          carDataList[index]['name'],
                                          formatDateRange(
                                              carDataList[index]['start_date'],
                                              carDataList[index]['end_date']),
                                          carDataList[index]['price'] + 'RM',
                                          carDataList[index]['status'],
                                          carDataList,
                                          index,
                                          type: 'car',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no cars order!'),
                                  ),
                            packagesDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: packagesDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          packagesDataList[index]['name'],
                                          formatDateRange(
                                              packagesDataList[index]
                                                  ['start_date'],
                                              packagesDataList[index]
                                                  ['end_date']),
                                          packagesDataList[index]['price'] +
                                              'RM',
                                          packagesDataList[index]['status'],
                                          packagesDataList,
                                          index,
                                          type: 'package',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no packages order!'),
                                  ),
                            dutyDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dutyDataList.length,
                                      itemBuilder: (context, index) {
                                        print(dutyDataList[index]);
                                        dutyDataList[index]['name'] == null ? dutyDataList[index]['name'] = '': dutyDataList[index]['name'];
                                        return dataView(
                                          dutyDataList[index]['name'],
                                          '',
                                          dutyDataList[index]['price'] + 'RM',
                                          dutyDataList[index]['status'],
                                          dutyDataList,
                                          index,
                                          type: 'duty',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no duty order!'),
                                  ),
                            restaurantDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: restaurantDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          restaurantDataList[index]['name'] +
                                              "\nTable for: ${restaurantDataList[index]['num_of_persons']}",
                                          DateFormat('dd-MMM-yyyy h:mm a')
                                              .format(DateTime.parse(
                                                  restaurantDataList[index]
                                                      ['start_date'])),
                                          restaurantDataList[index]['price'] +
                                              'RM',
                                          restaurantDataList[index]['status'],
                                          restaurantDataList,
                                          index,
                                          type: 'restaurant',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child:
                                        Text('There is no restaurant order!'),
                                  ),
                            activityDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: activityDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          activityDataList[index]['name'],
                                          DateFormat('dd-MMM-yyyy h:mm a')
                                              .format(DateTime.parse(
                                                  activityDataList[index]
                                                      ['start_date'])),
                                          activityDataList[index]['price'] +
                                              'RM',
                                          activityDataList[index]['status'],
                                          activityDataList,
                                          index,
                                          type: 'activity',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no activity order!'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text('Please, login first!'),
              )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  void initApp() async {
    sessionUser = await Session().user();
    isLogin = await Session().isLogin();
    if (isLogin) {
      try {
        Response response = await Dio().get(
          '${URL.ordersListURL}${sessionUser['id']}',
          // data: FormData.fromMap({
          //   'customer_id': sessionUser['id'],
          // }),
        );
        Map<String, dynamic> data = response.data;
        if (data['error']) {
          SnackBarUtils.show(title: data['message'], isError: true);
        } else {
          print('data :${data['homestays']}');
          hotelDataList = data['hotels'];
          carDataList = data['cars'];
          packagesDataList = data['packages'];
          dutyDataList = data['duty'];
          restaurantDataList = data['restaurant'];
          activityDataList = data['activities'];
        }
      } catch (e) {
        SnackBarUtils.show(title: e.toString(), isError: true);
      }
    }
    isLoaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  Widget dataView(name, date, price, status, dataList, index,
      {required String type}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.smSize,
        horizontal: Dimensions.defaultSize,
      ),
      margin: const EdgeInsets.only(
        bottom: Dimensions.smSize,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: RGB.lightDarker.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          Dimensions.radiusSize,
        ),
      ),
      child: ListTile(
        onTap: () {},
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(
                Dimensions.smSize / 2,
              ),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: RGB.muted,
                borderRadius: BorderRadius.circular(
                  Dimensions.circleSize,
                ),
              ),
              child: Icon(
                type == "hotel"
                    ? Icons.apartment_outlined
                    : type == "car"
                        ? Icons.local_taxi_outlined
                        : type == "package"
                            ? Icons.redeem_outlined
                            : type == "duty"
                                ? Icons.shopping_bag_outlined
                                : type == "restaurant"
                                    ? Icons.restaurant_outlined
                                    : UniconsLine.calender,
              ),
            ),
          ],
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status == "0"
                  ? "Pending"
                  : status == "1"
                      ? "Confirmed"
                      : status == "2"
                          ? "Completed"
                          : "Cancelled",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: status == "0"
                    ? Colors.orange
                    : status == "1"
                        ? Colors.green
                        : status == "2"
                            ? Colors.blue
                            : Colors.red,
              ),
            ),
            if (status == "0")
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          title: Text("Cancel Order"),
                          content: Text(
                              "Are you sure you want to cancel the order?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cancelOrder(dataList[index]['order_id'],
                                    dataList, index);
                                Navigator.of(context).pop();
                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "No",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Cancel Order",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            if (date != "")
              SizedBox(
                height: 5,
              ),
            if (date != "")
              Text(
                date,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              price,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  void cancelOrder(String orderId, dataList, int index) async {
    try {
      EasyLoading.show(status: 'Cancelling Order...');

      Response response = await Dio().post(
        '${URL.orderStatusListURL}',
        queryParameters: {'orderId': orderId, 'status': '3'},
      );

      if (response.data['error']) {
        SnackBarUtils.show(title: response.data['message'], isError: true);
        EasyLoading.dismiss();
      } else {
        Map<String, dynamic> data = response.data;
        SnackBarUtils.show(title: data['message'], isError: false);
        setState(() {
          dataList![index]['status'] = "3";
        });
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();

      SnackBarUtils.show(title: e.toString(), isError: true);
    }
  }

  String formatDateRange(String startDateString, String endDateString) {
    DateTime startDate = DateTime.parse(startDateString);
    DateTime endDate = DateTime.parse(endDateString);

    String formattedStartDate = DateFormat('dd-MMM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MMM-yyyy').format(endDate);

    return '$formattedStartDate to $formattedEndDate';
  }
}


// public function getOrdersByCustomerId($customerId) {
//     $builder = $this->db->table('orders');
//     $builder->select('
//         orders.*,
//         hotels.name as hotel_name,
//         hotels.end_date as hotel_end_date,
//         hotels.price as hotel_price,
//         cars.name as car_name,
//         cars.end_date as car_end_date,
//         cars.price as car_price,
//         packages.name as package_name,
//         packages.end_date as package_end_date,
//         packages.price as package_price,
//         duty.name as duty_name,
//         duty.end_date as duty_end_date,
//         duty.price as duty_price,
//         restaurant.name as restaurant_name,
//         restaurant.end_date as restaurant_end_date,
//         restaurant.price as restaurant_price
//     ');
//     $builder->join('hotels', 'hotels.id = orders.hotel_id', 'left');
//     $builder->join('cars', 'cars.id = orders.car_id', 'left');
//     $builder->join('packages', 'packages.id = orders.package_id', 'left');
//     $builder->join('duty', 'duty.id = orders.duty_id', 'left');
//     $builder->join('restaurant', 'restaurant.id = orders.restaurant_id', 'left');
//     $builder->where('orders.customer_id', $customerId);
//     $orders = $builder->get()->getResultArray();
    
//     $response = [
//         'error' => false,
//         'hotels' => [],
//         'cars' => [],
//         'packages' => [],
//         'duty' => [],
//         'restaurant' => []
//     ];
    
//     foreach ($orders as $order) {
//         if ($order['hotel_id'] != null) {
//             array_push($response['hotels'], [
//                 'name' => $order['hotel_name'],
//                 'end_date' => $order['hotel_end_date'],
//                 'price' => $order['hotel_price']
//             ]);
//         }
//         if ($order['car_id'] != null) {
//             array_push($response['cars'], [
//                 'name' => $order['car_name'],
//                 'end_date' => $order['car_end_date'],
//                 'price' => $order['car_price']
//             ]);
//         }
//         if ($order['package_id'] != null) {
//             array_push($response['packages'], [
//                 'name' => $order['package_name'],
//                 'end_date' => $order['package_end_date'],
//                 'price' => $order['package_price']
//             ]);
//         }
//         if ($order['duty_id'] != null) {
//             array_push($response['duty'], [
//                 'name' => $order['duty_name'],
//                 'end_date' => $order['duty_end_date'],
//                 'price' => $order['duty_price']
//             ]);
//         }
//         if ($order['restaurant_id'] != null) {
//             array_push($response['restaurant'], [
//                 'name' => $order['restaurant_name'],
//                 'end_date' => $order['restaurant_end_date'],
//                 'price' => $order['restaurant_price']
//             ]);
//         }
//     }
    
//     return $response;
// }





// public function register()
// {
//     // Load the form validation library
//     $validation = \Config\Services::validation();
    
//     // Set the validation rules
//     $validation->setRules([
//         'email' => 'required|valid_email|is_unique[customers.email]',
//     ]);

//     // Check if the form data is valid
//     if (!$validation->withRequest($this->request)->run()) {
//         // Form data is invalid
//         return $this->response->setJSON(['error' => true, 'message' => $validation->getErrors()])
//                               ->setStatusCode(400);
//     } else {
//         // Form data is valid
//         $data = [
//             'email' => $_POST['email'] ?? "",
//             'password' => $_POST['password'] ?? "",
//             'name' => $_POST['name'] ?? "",
//             'phone' => $_POST['phone'] ?? "",
//             'created_at' => $this->datetime,
//         ];

//         $user = $this->customerModel->save($data);
        
//         if ($user) {
//             return $this->response->setJSON(['error' => false, 'user' => $user])
//                                   ->setStatusCode(200);
//         } else {
//             return $this->response->setJSON(['error' => true, 'message' => 'Invalid username or password'])
//                                   ->setStatusCode(401);
//         }
//     }
// }
