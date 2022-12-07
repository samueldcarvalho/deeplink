// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'firebase_options.dart';
import 'shared/services/stores_service/store_service.dart';
import 'shared/utils/http_override.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HttpOverrides.global = MyHttpoverrides();
  await StoreService.regiterStores();

  runApp(const AppWidget());
}
