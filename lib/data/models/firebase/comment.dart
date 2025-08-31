import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  final String content;
  final List<String> dislikeBy;
  final int dislikeCount;
  final List<String> likeBy;
  final int likeCount;
  final String? parentId; // Có thể null cho các CommentUserReq gốc
  final int replyCount;
  final DateTime timestamp;
  final String userId;
  final String userName;

  Comment({
    this.id,
    required this.content,
    required this.dislikeBy,
    required this.dislikeCount,
    required this.likeBy,
    required this.likeCount,
    this.parentId,
    required this.replyCount,
    required this.timestamp,
    required this.userId,
    required this.userName,
  });

  factory Comment.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final timestampFromFirebase = data['timestamp'];

    return Comment(
      id: data['id'],
      content: data['content'] ?? '',
      // Chuyển List<dynamic> từ Firebase thành List<String> một cách an toàn
      dislikeBy: List<String>.from(data['dislikeBy'] ?? []),
      dislikeCount: data['dislikeCount'] ?? 0,
      likeBy: List<String>.from(data['likeBy'] ?? []),
      likeCount: data['likeCount'] ?? 0,
      parentId: data['parentID'], // Giữ nguyên null nếu không tồn tại
      replyCount: data['replyCount'] ?? 0,
      // Đọc trực tiếp kiểu Timestamp
      timestamp: timestampFromFirebase?.toDate() ?? DateTime.now(),
      userId: data['userID'] ?? '',
      userName: data['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson({required String id}) {
    return {
      'id': id,
      'content': content,
      'dislikeBy': dislikeBy,
      'dislikeCount': dislikeCount,
      'likeBy': likeBy,
      'likeCount': likeCount,
      'parentID': parentId,
      'replyCount': replyCount,
      'timestamp': timestamp,
      'userID': userId,
      'userName': userName,
    };
  }
}
