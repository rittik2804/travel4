import 'package:get/get.dart';
import 'package:travel/other_screen.dart';
import 'package:travel/screens/activity_screen.dart';
import 'package:travel/screens/auth/country_code_screen.dart';
import 'package:travel/screens/auth/register_screen.dart';
import 'package:travel/screens/auth/sign_in_screen.dart';
import 'package:travel/screens/calenders/car_calender_screen.dart';
import 'package:travel/screens/calenders/package_calender_screen.dart';
import 'package:travel/screens/car_view_screen.dart';
import 'package:travel/screens/duty_screen.dart';
import 'package:travel/screens/home_screen.dart';
import 'package:travel/screens/home_stay_screen.dart';
import 'package:travel/screens/homestay_detail_screen.dart';
import 'package:travel/screens/hotel_details_screen.dart';
import 'package:travel/screens/hotel_view_screen.dart';
import 'package:travel/screens/package_view_screen.dart';
import 'package:travel/screens/profile_screen.dart';
import 'package:travel/screens/restaurant_screen.dart';
import 'package:travel/screens/room_details_screen.dart';
import 'package:travel/screens/search_screen.dart';
import 'package:travel/screens/splash_screen.dart';
import 'package:travel/screens/ticket_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/signin', page: () => const SignInScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(name: '/country_code', page: () => const CountryCodeScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/hotel_details', page: () => const HotelDetailsScreen()),
    GetPage(name: '/homestay_detail', page: () => const HomeStayDetailScreen()),
    GetPage(name: '/room_details', page: () => const RoomDetailsScreen()),
    GetPage(name: '/hotel', page: () => const HotelViewScreen()),
    GetPage(name: '/car', page: () => const CarViewScreen()),
    GetPage(name: '/car_details', page: () => const CarDetailsScreen()),
    GetPage(name: '/package', page: () => const PackageViewScreen()),
    GetPage(name: '/package_details', page: () => const PackageDetailsScreen()),
    GetPage(name: '/profile', page: () => const ProfileScreen()),
    GetPage(name: '/duty', page: () => const DutyScreen()),
    GetPage(name: '/restaurant', page: () => const RestaurantScreen()),
    GetPage(name: '/activity', page: () => const ActivityScreen()),
    GetPage(name: '/search', page: () => const SearchScreen()),
    GetPage(name: '/homestay', page: () => const HomeStayScreen()),
    GetPage(name: '/ticket', page: () => const TicketScreen()),
    GetPage(name: '/other', page: () => const OtherScreen()),
    GetPage(name: '/payment-status', page: () => const HomeScreen()),

  ];
}
