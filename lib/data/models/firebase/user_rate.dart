import 'package:cloud_firestore/cloud_firestore.dart';

class UserRate {
  final String slug; // Thêm trường slug để xác định sách
  final double currentRate;
  final String userId;
  final int userRate;

  UserRate({
    required this.userId,
    required this.slug,
    required this.userRate,
    required this.currentRate,
  });

  factory UserRate.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return UserRate(
      slug: snap.id, // Sử dụng ID của document làm slug
      userId: data['user_id'] ?? '',
      userRate: data['user_rate'] ?? 0,
      currentRate: data['current_rate'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_rate': userRate,
      'current_rate': currentRate,
    };
  }
}
