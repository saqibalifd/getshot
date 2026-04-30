import 'package:getshotapp/models/screenshot_model.dart';

class DeviceModel {
  final String name;
  final String role;
  final String ipadress;
  final DateTime lastActive;
  final String longitude;
  final String latitude;
  final bool activeStatus;
  final List<ScreenshotModel> screenshots;

  DeviceModel({
    required this.name,
    required this.role,
    required this.ipadress,
    required this.lastActive,
    required this.longitude,
    required this.latitude,
    required this.activeStatus,
    required this.screenshots,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      ipadress: json['ipadress'] ?? '', // keeping your DB spelling
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : DateTime.now(),
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      activeStatus: json['activeStatus'] ?? false,
      screenshots:
          (json['screenshots'] as List<dynamic>?)
              ?.map((e) => ScreenshotModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'ipadress': ipadress,
      'lastActive': lastActive.toIso8601String(),
      'longitude': longitude,
      'latitude': latitude,
      'activeStatus': activeStatus,
      'screenshots': screenshots.map((e) => e.toJson()).toList(),
    };
  }
}
