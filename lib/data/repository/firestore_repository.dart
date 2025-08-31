import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/data_sources/firestore/firestore_service.dart';
import 'package:fluter_comic/data/models/firebase/user_rate.dart';
import 'package:fluter_comic/data/models/firebase/comment.dart';
import 'package:fluter_comic/data/models/firebase/get_rate.dart';

abstract class FirestoreRepository {
  Stream<Either<String, List<Comment>>> getCommentsStream(String slug);
  Future<Either<String, String>> addComment(
    Comment commentRequest,
    String slug,
  );
  Future<Either<String, String>> replyComment(Comment commentRequest);
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

class FirestoreRepositoryImpl extends FirestoreRepository {
  final FirestoreService _firestoreService;

  FirestoreRepositoryImpl({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  @override
  Stream<Either<String, List<Comment>>> getCommentsStream(String slug) {
    return _firestoreService.getCommentsStream(slug);
  }

  @override
  Future<Either<String, String>> addComment(
    Comment commentRequest,
    String slug,
  ) {
    return _firestoreService.addComment(commentRequest, slug);
  }

  @override
  Future<Either<String, String>> replyComment(Comment commentRequest) {
    return _firestoreService.replyComment(commentRequest);
  }

  @override
  Future<Either<String, String>> likeComment(
    String slug,
    String commentId,
    String userId,
    bool isLiked,
  ) {
    return _firestoreService.likeComment(slug, commentId, userId, isLiked);
  }

  @override
  Future<Either<String, String>> disLikeComment(
    String slug,
    String commentId,
    String userId,
    bool isDisLiked,
  ) {
    return _firestoreService.disLikeComment(
      slug,
      commentId,
      userId,
      isDisLiked,
    );
  }

  @override
  Stream<Either<String, GetRate>> getRateStream(String slug) {
    return _firestoreService.getRateStream(slug);
  }

  @override
  Future<Either<String, String>> addRate(UserRate rateInfo) {
    return _firestoreService.addRate(rateInfo);
  }
}
