import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationUtils {
  static Future<String> getAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          // Nominatim requires a User-Agent header
          'User-Agent': 'GetShotApp/1.0',
          'Accept-Language': 'en',
        },
      );

      if (response.statusCode != 200) {
        return 'Address not found';
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data.containsKey('error')) {
        return 'Address not found';
      }

      final address = data['address'] as Map<String, dynamic>;

      final parts = <String>[
        if (address['road'] != null) address['road'] as String,
        if (address['suburb'] != null) address['suburb'] as String,
        if (address['city'] != null)
          address['city'] as String
        else if (address['town'] != null)
          address['town'] as String
        else if (address['village'] != null)
          address['village'] as String,
        if (address['state'] != null) address['state'] as String,
        if (address['country'] != null) address['country'] as String,
      ];

      return parts.isEmpty ? 'Unknown location' : parts.join(', ');
    } catch (e) {
      return 'Error fetching address';
    }
  }
}
