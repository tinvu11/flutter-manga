part of 'comment_bloc.dart';

@freezed
abstract class CommentEvent with _$CommentEvent {
  const factory CommentEvent.loadComments({required String comicId}) =
      _LoadComments;
  const factory CommentEvent.addComment({
    required Comment comment,
    required String slug,
  }) = _AddComment;
  const factory CommentEvent.likeComment({
    required String slug,
    required String commentId,
    required String userId,
    required bool isLiked,
  }) = _Like;
  const factory CommentEvent.disLikeComment({
    required String slug,
    required String commentId,
    required String userId,
    required bool isDisLiked,
  }) = _DisLike;
}
