class URL {
  static String baseURL = 'https://admin.mybooking.my/public/api/';
  // static String baseURL = 'http://192.168.34.33:8080/api/';
  static String loginURL = '${baseURL}login.php';
  static String signUpURL = '${baseURL}register.php';
  static String forgotPasswordURL = '${baseURL}forgotpassword.php';
  static String hotelURL = '${baseURL}hotel.php';
  static String hotelCalenderURL = '${baseURL}hotelcalender/';
  static String carURL = '${baseURL}car.php';
  static String carCalenderURL = '${baseURL}carcalender/';
  static String packageURL = '${baseURL}package.php';
  static String packageCalenderURL = '${baseURL}packagecalender/';
  static String orderURL = '${baseURL}order.php';
  static String orderAddURL = '${baseURL}order_add.php';
  static String ordersListURL = '${baseURL}orders/';
  static String orderStatusListURL = '${baseURL}customer/orderstatus';
  static String dutyURL = '${baseURL}duty.php';
  static String restaurantURL = '${baseURL}restaurant.php';
  static String activityURL = '${baseURL}activity.php';
  static String homestayURL = '${baseURL}homestay.php';
  static String deleteAccountURL = '${baseURL}customer/deleteaccount/';
  static String ticketURL = '${baseURL}ticket.php';
  static String otherURL = '${baseURL}other.php';
  // photo url
  static String photoURL = 'https://admin.mybooking.my/public/uploads/';
  static String roomsPhotoURL =
      'https://admin.mybooking.my/public/uploads/hotel_rooms/';

  /// booking
  static String bookHotelURL = '${baseURL}hotelbook';
  static String bookCarURL = '${baseURL}carbook';
  static String bookPackageURL = '${baseURL}packagebook';
  static String bookRestaurantURL = '${baseURL}restaurantbook';
  static String bookDutyURL = '${baseURL}dutybook';
  static String bookActivityURL = '${baseURL}activitybook';
}
