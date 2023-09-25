import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:travel/config/session.dart';
import 'package:travel/screens/home_status_screen.dart';
import 'package:travel/screens/order_screen.dart';
import 'package:travel/screens/profile_screen.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/payment_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  Map sessionUser = {};

  List widgetList = const [
    HomeStatusScreen(),
    OrderScreen(),
    WhatsAppOpen(),
    ProfileScreen(),
  ];

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
        automaticallyImplyLeading: false,
        elevation: 1,
        title: GestureDetector(
          onTap: () async {
            if (!await Session().isLogin()) {
              Get.toNamed('/signin');
            }
          },
          child: Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(
                width: Dimensions.smSize,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sessionUser['name'] != null) ...[
                    Text(
                      sessionUser['name'],
                      style: const TextStyle(
                        fontSize: Dimensions.smSize + 2,
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Log in\nTo enjoy member discounts',
                      style: TextStyle(
                        fontSize: Dimensions.smSize + 2,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: Dimensions.defaultSize,
            ),
            child: Row(
              children: [
                if (sessionUser['name'] != null) ...[
                  GestureDetector(
                    onTap: () async {
                      EasyLoading.show(status: 'loading...');
                      await Session().userFlash();
                      EasyLoading.dismiss();
                      Get.offAllNamed('/home');
                    },
                    child: const Icon(Icons.logout_outlined),
                  ),
                ] else ...[
                  const Icon(Icons.search_outlined),
                ],
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: widgetList.elementAt(activeIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: RGB.white,
        color: RGB.darkLight,
        activeColor: RGB.primary,
        height: 60,
        items: const [
          TabItem(
            icon: UniconsLine.estate,
            title: 'Home',
          ),
          TabItem(
            icon: Icons.task_outlined,
            title: 'Orders',
          ),
          TabItem(
            icon: Icons.forum,
            title: 'Chats',
          ),
          TabItem(
            icon: Icons.person,
            title: 'Account',
          ),
        ],
        initialActiveIndex: 0,
        onTap: (int i) async {
          activeIndex = i;
          setState(() {});
        },
      ),
    );
  }

  Container name(String name, String title) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(
        Dimensions.smSize,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: Dimensions.smSize / 2,
        horizontal: Dimensions.defaultSize,
      ),
      decoration: BoxDecoration(
        color: RGB.muted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(
          Dimensions.radiusSize,
        ),
      ),
      child: Text(
        "$title: $name",
      ),
    );
  }

  // functional task
  void initApp() async {
    sessionUser = await Session().user();
    setState(() {});
  }
}

class WhatsAppOpen extends StatefulWidget {
  const WhatsAppOpen({super.key});

  @override
  State<WhatsAppOpen> createState() => _WhatsAppOpenState();
}

class _WhatsAppOpenState extends State<WhatsAppOpen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var whatsapp = "+60197300287";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=Welcome");
    if (kIsWeb) {
      await launchUrl(Uri.parse(
          "https://api.whatsapp.com/send?phone=$whatsapp&text=Welcome"));
    } else {
      if (await canLaunchUrl(whatsappAndroid)) {
        await launchUrl(whatsappAndroid);
      } else {
        SnackBarUtils.show(
          title: "WhatsApp is not installed on the device",
          isError: true,
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Get.offAllNamed('home');
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
