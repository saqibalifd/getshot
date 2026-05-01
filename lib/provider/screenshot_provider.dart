import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScreenshotProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;
}
