import 'package:flutter/material.dart';
import 'package:fluter_comic/data/models/firebase/comment.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String userId;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onReply;
  final Function(bool) onToggleReplies;

  const CommentItem({
    Key? key,
    required this.userId,
    required this.comment,
    required this.onLike,
    required this.onDislike,
    required this.onReply,
    required this.onToggleReplies,
  }) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _repliesVisible = false;

  @override
  void initState() {
    super.initState();
  }

  // Lấy trạng thái like/dislike trực tiếp từ dữ liệu comment
  bool get _isLiked => widget.comment.likeBy.contains(widget.userId);
  bool get _isDisliked => widget.comment.dislikeBy.contains(widget.userId);

  // Giữ nguyên logic format thời gian của bạn, nó rất tốt!
  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(theme),
                    const SizedBox(height: 4),
                    _buildCommentContent(theme),
                    const SizedBox(height: 8),
                    _buildActionButtons(theme),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replyCount > 0) ...[
            const SizedBox(height: 8),
            _buildRepliesToggle(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade300,
            Colors.purple.shade300,
            Colors.pink.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.comment.userName.isNotEmpty
              ? widget.comment.userName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.comment.userName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        // const Spacer(),
        Text(
          _formatTimeAgo(widget.comment.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentContent(ThemeData theme) {
    return Text(widget.comment.content, style: theme.textTheme.bodyMedium);
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        _buildActionButton(
          theme: theme,
          icon: Icons.thumb_up_outlined,
          activeIcon: Icons.thumb_up,
          count: widget.comment.likeBy.length,
          isActive: _isLiked,
          activeColor: Colors.blue,
          onTap: () {
            widget.onLike();
          },
        ),
        const SizedBox(width: 18),
        _buildActionButton(
          theme: theme,
          icon: Icons.thumb_down_outlined,
          activeIcon: Icons.thumb_down,
          count: widget.comment.dislikeBy.length,
          isActive: _isDisliked,
          activeColor: Colors.red,
          onTap: () {
            widget.onDislike();
          },
        ),
        const Spacer(), // Đẩy nút trả lời ra xa
        _buildReplyButton(theme),
      ],
    );
  }

  Widget _buildActionButton({
    required ThemeData theme,
    required IconData icon,
    required IconData activeIcon,
    required int count,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final color = isActive
        ? activeColor
        : theme.textTheme.bodySmall?.color?.withOpacity(0.7);

    // Sử dụng InkWell để có hiệu ứng ripple đẹp mắt
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, size: 18, color: color),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (count == 0) ...[
            const SizedBox(width: 6),
            Text(
              '0',
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyButton(ThemeData theme) {
    return InkWell(
      onTap: widget.onReply,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(
              Icons.reply,
              size: 18,
              color: theme.textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 6),
            Text(
              'Trả lời',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesToggle(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _repliesVisible = !_repliesVisible;
        });
        widget.onToggleReplies(_repliesVisible);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _repliesVisible
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${_repliesVisible ? "Ẩn" : "Xem"} ${widget.comment.replyCount} phản hồi',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
