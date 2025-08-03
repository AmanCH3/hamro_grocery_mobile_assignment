import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/app.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init Hive service
  await HiveService().init();
  await initDependencies();

  runApp(MyApp());
}
