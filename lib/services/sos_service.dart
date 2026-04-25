import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'storage_service.dart';

class SOSService {
  static Future<String> triggerSOS() async {
    final permission = await Permission.location.request();

    if (!permission.isGranted) {
      return 'Location permission denied';
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final contacts = await StorageService.getContacts();

      final locationLink =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      if (contacts.isEmpty) {
        return 'SOS Triggered!\nNo trusted contacts saved.\nLocation:\n$locationLink';
      }

      final contactNames =
          contacts.map((c) => c['name'] ?? 'Unknown').join(', ');

      return 'SOS Triggered!\nSending alert to: $contactNames\nLocation:\n$locationLink';
    } catch (e) {
      return 'Failed to get location';
    }
  }
}