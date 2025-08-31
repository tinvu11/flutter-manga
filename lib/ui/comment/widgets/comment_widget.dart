import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/common/mixins/authentication_mixin.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/models/firebase/comment.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:fluter_comic/ui/comment/bloc/comment_bloc.dart';
import 'package:fluter_comic/ui/comment/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentWidget extends StatefulWidget {
  final String slug;
  const CommentWidget({super.key, required this.slug});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    with AuthenticationMixin {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCommentList(List<Comment> comments) {
    if (comments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.comment_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Chưa có bình luận',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final currentUser = authState.maybeMap(
          authenticated: (value) =>
              (uid: value.user.uid, userName: value.user.name),
          orElse: () => (uid: null, userName: null),
        );

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return CommentItem(
              userId: currentUser.uid ?? '',
              comment: comment,
              onLike: () => _handleLike(comment, currentUser.uid),
              onDislike: () => _handleDislike(comment, currentUser.uid),
              onReply: () {
                // Handle reply action
              },
              onToggleReplies: (visible) {
                // Handle toggle replies action
              },
            );
          },
        );
      },
    );
  }

  void _handleLike(Comment comment, String? uid) {
    executeWithAuth(() {
      if (comment.dislikeBy.contains(uid)) {
        context.read<CommentBloc>().add(
          CommentEvent.disLikeComment(
            commentId: comment.id!,
            slug: widget.slug,
            userId: uid!,
            isDisLiked: true,
          ),
        );
      }
      context.read<CommentBloc>().add(
        CommentEvent.likeComment(
          slug: widget.slug,
          commentId: comment.id!,
          userId: uid!,
          isLiked: comment.likeBy.contains(uid),
        ),
      );
    });
  }

  void _handleDislike(Comment comment, String? uid) {
    executeWithAuth(() {
      if (comment.likeBy.contains(uid)) {
        context.read<CommentBloc>().add(
          CommentEvent.likeComment(
            commentId: comment.id!,
            slug: widget.slug,
            userId: uid!,
            isLiked: true,
          ),
        );
      }
      context.read<CommentBloc>().add(
        CommentEvent.disLikeComment(
          commentId: comment.id!,
          slug: widget.slug,
          userId: uid!,
          isDisLiked: comment.dislikeBy.contains(uid),
        ),
      );
    });
  }

  void _submitComment() {
    final value = commentController.text.trim();
    if (value.isEmpty) return;

    executeWithAuth(() {
      final currentUser = getCurrentUser();
      context.read<CommentBloc>().add(
        CommentEvent.addComment(
          comment: Comment(
            content: value,
            dislikeBy: [],
            dislikeCount: 0,
            likeBy: [],
            likeCount: 0,
            replyCount: 0,
            timestamp: DateTime.now(),
            userId: currentUser.uid!,
            userName: currentUser.userName!,
          ),
          slug: widget.slug,
        ),
      );
      commentController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) =>
          CommentBloc(firestoreRepository: DI().sl<FirestoreRepository>())
            ..add(CommentEvent.loadComments(comicId: widget.slug)),
      child: Scaffold(
        backgroundColor: colorScheme.surface,

        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  return state.when(
                    initial: () =>
                        const Center(child: Text('Chưa có bình luận')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (comments) {
                      return _buildCommentList(comments);
                    },
                    error: (error) =>
                        Center(child: Text('Error: ${error.toString()}')),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                autofocus: false,
                controller: commentController,
                textInputAction: TextInputAction.done,
                maxLines: null,
                onSubmitted: (value) {
                  _submitComment();
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded, color: colorScheme.primary),
                    onPressed: _submitComment,
                  ),

                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: 'Chia sẻ suy nghĩ của bạn...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
