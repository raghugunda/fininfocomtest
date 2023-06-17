

class ImageData {
  String status;
  String message;

  ImageData({
    required this.status,
    required this.message,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    status: json["status"],
    message: json["message"],
  );
}