import 'package:getshotapp/models/screenshot_model.dart';

class AllUserModel {
  final String name;
  final String role;
  final String ipadress;
  final DateTime lastActive;
  final bool activeStatus;
  final List<ScreenshotModel> screenshots;

  const AllUserModel({
    required this.name,
    required this.role,
    required this.ipadress,
    required this.lastActive,
    required this.activeStatus,
    required this.screenshots,
  });
}
