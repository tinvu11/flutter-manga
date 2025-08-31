import 'package:cloud_firestore/cloud_firestore.dart';

class GetRate {
  final String id;
  final Map<String, dynamic> rateBy;
  final int count;
  final double rate;
  // Các trường khác của sách như title, author, thumbUrl... cũng sẽ được thêm vào đây

  GetRate({
    required this.id,
    required this.count,
    required this.rate,
    required this.rateBy,
  });

  // Factory để tạo object ComicRateInfo từ DocumentSnapshot của Firebase
  factory GetRate.fromSnapshot(DocumentSnapshot snap) {
    // Lấy dữ liệu từ snapshot dưới dạng Map
    final data = snap.data() as Map<String, dynamic>;

    return GetRate(
      rateBy: data['rateBy'] ?? {},
      id: snap.id,
      count: data['count'] ?? 0,
      // Chuyển đổi sang double để xử lý các rate dạng số thực (ví dụ: 8.5)
      rate: (data['rate'] ?? 0).toDouble(),
    );
  }

  // Phương thức để chuyển object thành Map, dùng khi ghi dữ liệu lên Firebase
  Map<String, dynamic> toJson() {
    return {'count': count, 'rate': rate};
  }
}
