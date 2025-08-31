import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/models/firebase/comment.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'comment_bloc.freezed.dart';
part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final FirestoreRepository _firestoreRepository;
  StreamSubscription? _rateSubscription;
  CommentBloc({required FirestoreRepository firestoreRepository})
    : _firestoreRepository = firestoreRepository,
      super(const CommentState.initial()) {
    on<CommentEvent>((event, emit) async {
      await event.map(
        loadComments: (e) => _onFetch(e, emit),
        addComment: (e) => _onAddComment(e, emit),
        likeComment: (e) => _onLikeComment(e, emit),
        disLikeComment: (e) => _onDisLikeComment(e, emit),
      );
    });
  }
  Future<void> _onFetch(_LoadComments event, Emitter<CommentState> emit) async {
    try {
      emit(const CommentState.loading());
      print('Fetching comments for comic: ${event.comicId}');
      await emit.forEach<Either<String, List<Comment>>>(
        _firestoreRepository.getCommentsStream(event.comicId),
        onData: (result) {
          return result.fold(
            (failure) => CommentState.error(message: failure),
            (comments) => CommentState.loaded(comments: comments),
          );
        },
        onError: (error, stackTrace) =>
            CommentState.error(message: error.toString()),
      );
    } catch (e) {
      emit(CommentState.error(message: e.toString()));
    }
  }

  Future<void> _onAddComment(
    _AddComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      final result = await _firestoreRepository.addComment(
        event.comment,
        event.slug,
      );
      result.fold(
        (failure) => emit(CommentState.error(message: failure)),
        // (success) => add(CommentEvent.loadComments(event.comment.slug)),
        (success) => null,
      );
    } catch (e) {
      emit(CommentState.error(message: e.toString()));
    }
  }

  Future<void> _onLikeComment(_Like event, Emitter<CommentState> emit) async {
    try {
      final result = await _firestoreRepository.likeComment(
        event.slug,
        event.commentId,
        event.userId,
        event.isLiked,
      );
      result.fold(
        (failure) => emit(CommentState.error(message: failure)),
        // (success) => add(CommentEvent.loadComments(event.slug)),
        (success) => null,
      );
    } catch (e) {
      emit(CommentState.error(message: e.toString()));
    }
  }

  Future<void> _onDisLikeComment(
    _DisLike event,
    Emitter<CommentState> emit,
  ) async {
    try {
      final result = await _firestoreRepository.disLikeComment(
        event.slug,
        event.commentId,
        event.userId,
        event.isDisLiked,
      );
      result.fold(
        (failure) => emit(CommentState.error(message: failure)),
        // (success) => add(CommentEvent.loadComments(event.slug)),
        (success) => null,
      );
    } catch (e) {
      emit(CommentState.error(message: e.toString()));
    }
  }
}
