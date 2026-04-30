class ScreenshotModel {
  final String downloadUrl;
  final String id;

  ScreenshotModel({required this.downloadUrl, required this.id});

  factory ScreenshotModel.fromJson(Map<String, dynamic> json) {
    return ScreenshotModel(
      downloadUrl: json['downloadUrl'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'downloadUrl': downloadUrl, 'id': id};
  }
}
