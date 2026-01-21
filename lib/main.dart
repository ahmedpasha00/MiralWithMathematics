import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miral_with_mathematics/miral_with_mathematics.dart';
import 'firebase_options.dart';


final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();


void main() async {

  // 1. تأمين تشغيل المكتبات
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 2. تشغيل فايربيز مرة واحدة فقط
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // ✨ تفعيل خاصية العمل بدون إنترنت للبيانات (Offline Persistence) ✨
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    print("✅ مبروك! ميرال اتصلت بفايربيز بنجاح وفعلنا نظام الـ Offline");
  } catch (e) {
    print("❌ حصل مشكلة في الاتصال: $e");
  }

  // 3. إعدادات الشاشة (عرضي وملء الشاشة)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);


  // 4. تشغيل التطبيق
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: const MiralWithMathematics(),
    ),
  );
}