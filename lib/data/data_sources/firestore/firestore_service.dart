import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/models/firebase/get_rate.dart';
import 'package:fluter_comic/data/models/firebase/comment.dart';
import 'package:fluter_comic/data/models/firebase/user_rate.dart';

abstract interface class FirestoreService {
  // repository_interface.dart
  Stream<Either<String, List<Comment>>> getCommentsStream(String slug);
  Future<Either<String, String>> addComment(
    Comment commentRequest,
    String slug,
  );
  Future<Either<String, String>> replyComment(Comment commentRequest);
  Stream<Either<String, List<Comment>>> getRepliesStream(
    String bookId,
    String commentId,
  );
  Future<Either<String, String>> likeComment(
    String slug,
    String commentId,
    String userId,
    bool isLiked,
  );
  Future<Either<String, String>> disLikeComment(
    String slug,
    String commentId,
    String userId,
    bool isDisLiked,
  );

  Stream<Either<String, GetRate>> getRateStream(String slug);
  Future<Either<String, String>> addRate(UserRate rateInfo);
}

class FirestoreServiceImpl implements FirestoreService {
  FirestoreServiceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // repository_implementation.dart
  @override
  Stream<Either<String, List<Comment>>> getCommentsStream(String slug) {
    return _firestore
        .collection('books')
        .doc(slug)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots() // Đây là điểm thay đổi quan trọng
        .map((querySnapshot) {
          // map để biến đổi Stream<QuerySnapshot> thành Stream<List<Comment>>
          final comments = querySnapshot.docs
              .map((doc) => Comment.fromSnapshot(doc))
              .toList();
          // Gói danh sách comment vào Right() để báo hiệu thành công
          return Right<String, List<Comment>>(comments);
        });
  }

  // repository_implementation.dart
  @override
  Stream<Either<String, GetRate>> getRateStream(String slug) {
    try {
      // Giả sử thông tin rate nằm trong document của chính article đó
      return _firestore
          .collection('books')
          .doc(slug)
          .snapshots() // Lắng nghe thay đổi của một document duy nhất
          .map((documentSnapshot) {
            if (documentSnapshot.exists) {
              final data = documentSnapshot.data();

              if (data != null) {
                // Nếu document tồn tại, tạo đối tượng GetRate
                final rateData = GetRate.fromSnapshot(documentSnapshot);

                return Right<String, GetRate>(rateData);
              } else {
                return Left<String, GetRate>(
                  'Document tồn tại nhưng không có dữ liệu.',
                );
              }
            } else {
              // Nếu document không tồn tại, trả về default values thay vì lỗi
              final defaultRate = GetRate(
                id: slug,
                rate: 0,
                count: 0,
                rateBy: {},
              );
              return Right<String, GetRate>(defaultRate);
            }
          });
    } catch (e) {
      return Stream.value(Left('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, String>> addRate(UserRate rateInfo) async {
    try {
      final docRef = _firestore.collection('books').doc(rateInfo.slug);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) {
          tx.set(docRef, {
            'sum': rateInfo.userRate,
            'count': 1,
            'rate': rateInfo.userRate,
            'rateBy': {rateInfo.userId: rateInfo.userRate},
          }, SetOptions(merge: true));
          return;
        }
        final data = snap.data() ?? {};

        final Map<String, dynamic> rateBy = Map<String, dynamic>.from(
          data['rateBy'] ?? {},
        );
        final double prev = (rateBy[rateInfo.userId] ?? 0.0) * 1.0;

        final double sum = (data['sum'] ?? 0.0) * 1.0;
        final int count = (data['count'] ?? 0);

        final bool isNewUser = !rateBy.containsKey(rateInfo.userId);

        final double newSum = isNewUser
            ? sum + rateInfo.currentRate
            : sum - prev + rateInfo.currentRate;

        final int newCount = isNewUser ? count + 1 : count;
        final double newAvg = newCount > 0 ? newSum / newCount : 0.0;

        tx.update(docRef, {
          'sum': newSum,
          'count': newCount,
          'rate': newAvg,
          'rateBy.${rateInfo.userId}':
              rateInfo.currentRate, // 👈 cập nhật theo uid
        });
      });

      return Right('thanh cong');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addComment(
    Comment commentRequest,
    String slug,
  ) async {
    try {
      final docRef = _firestore
          .collection('books')
          .doc(slug)
          .collection('comments')
          .doc();
      await docRef.set(commentRequest.toJson(id: docRef.id));
      return Right(docRef.id);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> replyComment(Comment commentRequest) async {
    try {
      // await _firestore
      //     .collection('books')
      //     .doc(commentRequest.id)
      //     .collection('comments')
      //     .doc(commentRequest.parentId)
      //     .collection('replies')
      //     .add(commentRequest.toJson());

      return Right('Comment replied successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<Comment>>> getRepliesStream(
    String bookId,
    String commentId,
  ) {
    return _firestore
        .collection('books')
        .doc(bookId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => Right<String, List<Comment>>(
            snapshot.docs.map((doc) => Comment.fromSnapshot(doc)).toList(),
          ),
        );
  }

  @override
  Future<Either<String, String>> likeComment(
    String slug,
    String commentId,
    String userId,
    bool isLiked,
  ) async {
    try {
      final commentRef = _firestore
          .collection('books')
          .doc(slug)
          .collection('comments')
          .doc(commentId);
      if (isLiked) {
        await commentRef.update({
          'likeBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await commentRef.update({
          'likeBy': FieldValue.arrayUnion([userId]),
        });
      }

      return Right('Liked successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> disLikeComment(
    String slug,
    String commentId,
    String userId,
    bool isDisLiked,
  ) async {
    try {
      final commentRef = _firestore
          .collection('books')
          .doc(slug)
          .collection('comments')
          .doc(commentId);

      if (isDisLiked) {
        await commentRef.update({
          'dislikeBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await commentRef.update({
          'dislikeBy': FieldValue.arrayUnion([userId]),
        });
      }

      return Right('Liked successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
