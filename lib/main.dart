import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'package:get/get.dart';
import 'pages/rescue.dart' as resq;
import 'pages/home.dart' as home;
import 'pages/donation.dart' as dona;
import 'pages/adoptform.dart' as adopt;
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<adopt.CandidateController>(() => adopt.CandidateController());
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            theme: themeProvider.themeData,
            initialRoute: "/",
            getPages: [
              GetPage(name: "/", page: () => const home.HomePage()),
              GetPage(name: "/rescue", page: () => const resq.RescuePage()),
              GetPage(name: "/donate", page: () => const dona.DonationPage()),
            ],
          );
        },
      ),
    ),
  );
}