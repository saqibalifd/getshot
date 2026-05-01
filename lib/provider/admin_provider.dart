import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/device_model.dart';

class AdminProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  String? _error;

  List<DeviceModel> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==============================
  // 🔄 FETCH DATA
  // ==============================
  Future<void> fetchDeviceData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase.from('userdata').select();

      _devices = (response as List)
          .map((item) => DeviceModel.fromJson(item))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // 🧨 CLEAR ALL TABLE DATA
  // ==============================
  Future<void> clearAllData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.from('userdata').delete().neq('ipadress', '');

      _devices.clear();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // 📸 CLEAR ONLY SCREENSHOTS FIELD
  // ==============================
  Future<void> clearAllScreenshots(String ipAddress) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Update only the row with matching IP
      await _supabase
          .from('userdata')
          .update({'screenshots': []})
          .eq('ipadress', ipAddress); // 👈 IMPORTANT FILTER

      // Update local state only for that device
      _devices = _devices.map((device) {
        if (device.ipadress == ipAddress) {
          return DeviceModel(
            name: device.name,
            role: device.role,
            ipadress: device.ipadress,
            longitude: device.longitude,
            latitude: device.latitude,
            lastActive: device.lastActive,
            activeStatus: device.activeStatus,
            screenshots: [], // cleared
          );
        }
        return device;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestScreenshot(String ipadress) async {
    await Supabase.instance.client.from('screenshot_commands').insert({
      'status': 'pending',
      'target_ip': ipadress, // from userdata table
    });
  }
}
