import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class PushNotificationFirebaseService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<void> init() async {
    // push notification yuborish uchun ruxsat so'raymiz
    final notificationSettings = await _pushNotification.requestPermission();

    // qurilmani TOKEN'ni olamiz
    // shu orqali qaysi qurilmaga xabarnoma yuborishni aniqlaymiz
    final token = await _pushNotification.getToken();
    print("Token: $token");

    // backgrounda xabar kelsa ishlaydi
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("XABAR ORQALI DASTURNI OCHGANDA KELDI");
      print('XAbar: $message');
    });

    // foregroundda xabar kelsa ishlaydi
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('DASTURDA BO\'LGANDA XABAR KELDI');
      print('Xabar: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });

    await FirebaseMessaging.instance.subscribeToTopic("Topic");
  }

  static void sendNotificationMessage({
    required String pushToken,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    print(client.credentials.accessToken);

    final notificationData = {
      'message': {
        'token': pushToken,
        'notification': {'title': title, 'body': body}
      },
    };

    const projectId = "flutter-day-46";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }

    // print('Notification Sending Error Response status: ${response.statusCode}');
    // print('Notification Response body: ${response.body}');
  }
}
