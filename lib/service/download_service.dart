import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  /// Downloads an image from [url] to the system Downloads folder.
  /// [onProgress] callback receives values from 0.0 to 1.0.
  /// Returns the saved file path on success.
  static Future<String> downloadImage({
    required String url,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    final Uri uri = Uri.parse(url);
    final http.Client client = http.Client();

    try {
      // Send a streamed GET request so we can track bytes as they arrive
      final http.StreamedResponse response = await client.send(
        http.Request('GET', uri),
      );

      if (response.statusCode != 200) {
        throw Exception('Server returned status ${response.statusCode}');
      }

      final int total = response.contentLength ?? 0;
      int received = 0;

      final String savePath = await _getDownloadPath(fileName);
      final File file = File(savePath);
      final IOSink sink = file.openWrite();

      // Write each incoming chunk to disk and report progress
      await response.stream.listen((List<int> chunk) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) {
          onProgress(received / total);
        }
      }).asFuture();

      await sink.flush();
      await sink.close();

      return savePath;
    } finally {
      client.close();
    }
  }

  static Future<String> _getDownloadPath(String fileName) async {
    Directory downloadsDir;

    if (Platform.isWindows) {
      final String home = Platform.environment['USERPROFILE'] ?? '';
      downloadsDir = Directory('$home\\Downloads');
    } else if (Platform.isMacOS) {
      final Directory docDir = await getApplicationDocumentsDirectory();
      final String home = docDir.path.split('Documents').first;
      downloadsDir = Directory('${home}Downloads');
    } else if (Platform.isLinux) {
      final String home = Platform.environment['HOME'] ?? '';
      downloadsDir = Directory('$home/Downloads');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    // Avoid overwriting: append _1, _2 ... if file already exists
    String finalPath = '${downloadsDir.path}${Platform.pathSeparator}$fileName';
    int counter = 1;
    while (await File(finalPath).exists()) {
      final bool hasExt = fileName.contains('.');
      final String ext = hasExt ? '.${fileName.split('.').last}' : '';
      final String base = hasExt
          ? fileName.substring(0, fileName.lastIndexOf('.'))
          : fileName;
      finalPath =
          '${downloadsDir.path}${Platform.pathSeparator}${base}_$counter$ext';
      counter++;
    }

    return finalPath;
  }

  /// Extracts a safe filename from a URL.
  static String fileNameFromUrl(String url, {String fallback = 'image.png'}) {
    try {
      final Uri uri = Uri.parse(url);
      final String segment = uri.pathSegments.last;
      return segment.isNotEmpty ? segment : fallback;
    } catch (_) {
      return fallback;
    }
  }
}
