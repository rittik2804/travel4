import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:travel/routes/routes.dart';
import 'package:travel/screens/paymrnt_status_screen.dart';
import 'package:travel/theme/light_theme.dart';
import 'package:travel/utils/navigator_key.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // systemUI init
  LightTheme.systemUI;
  // DeviceOrientation init
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      GetMaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: LightTheme.lightThemeData,
        initialRoute: '/home',
        getPages: Routes.routes,
        navigatorKey: navigatorKey,
        builder: EasyLoading.init(),
      ),
    ),
  );
}
void runAppWithDeepLink(Map<String, String> queryParams) {
  // Here, you can navigate to the PaymentStatusScreen or perform any other action
  // based on the deep link data if needed.
  runApp(
    MaterialApp(
      home: PaymentStatusScreen(paymentData: []),
    ),
  );
}