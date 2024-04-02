
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('fcmToken');

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('FCM token refreshed: $newToken');
      updateTokenInDatabase(newToken);
    });
    if (fCMToken != null) {
      await _databaseReference.set({'token': fCMToken});
      print('FCM token saved to the database.');
    } else {
      print('Failed to get FCM token.');
    }
  }

  void updateTokenInDatabase(String newToken) async {
    await _databaseReference.set({'token': newToken});
    print('FCM token updated in the database.');
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  }
}
